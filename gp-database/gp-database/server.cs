using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Net;
using System.Threading;

namespace gp_database
{
    public class Server
    {
        List<Lobby> Lobbies;
        List<SocketHelper> Clients;
        List<SocketHelper> SearchingClients;
        Thread TCPThread;
        Thread PingThread;
        Thread MatchmakingThread;
        TcpListener TCPListener = null;

        private const int BufferAlignment = 1;
        private const int BufferSize = 256;
        private readonly string[] Maps = { "Open#Plains", "Riverside", "Lonely#Mountain", "Four#Islands", "Twin#Oasis", "Pyramid#Grounds", "Canyon#Valley", "Stone#Arena", "Caverns", "Sister#Caves", "Frozen#Lake", "Melting#Snow" };

        /// <summary>
        /// Starts the server.
        /// </summary>
        public void StartServer(int tcpPort)
        {
            //Creates a client list.
            Clients = new List<SocketHelper>();
            Lobbies = new List<Lobby>();
            SearchingClients = new List<SocketHelper>();

            //Starts a listen thread to listen for connections.
            TCPThread = new Thread(new ThreadStart(delegate
            {
                Listen(tcpPort);
            }));
            TCPThread.Start();
            Console.WriteLine("Listen thread started.");

            //Starts a ping thread to keep connection alive.
            PingThread = new Thread(new ThreadStart(delegate
            {
                Ping();
            }));
            PingThread.Start();
            Console.WriteLine("Ping thread started.");

            //Starts a matchmaking thread to create lobbies.
            MatchmakingThread = new Thread(new ThreadStart(delegate
            {
                Matchmaking();
            }));
            MatchmakingThread.Start();
            Console.WriteLine("Matchmaking thread started.");
        }

        /// <summary>
        /// Stops the server from running.
        /// </summary>
        public void StopServer()
        {
            TCPListener.Stop();

            TCPThread.Abort();
            PingThread.Abort();
            MatchmakingThread.Abort();

            foreach (SocketHelper client in Clients)
            {
                client.MscClient.GetStream().Close();
                client.MscClient.Close();
                client.ReadThread.Abort();
                client.WriteThread.Abort();
            }

            Clients.Clear();
            Lobbies.Clear();
        }

        /// <summary>
        /// Constantly pings clients with messages to see if they disconnect.
        /// </summary>
        private void Ping()
        {
            //Send ping to clients every 3 seconds.
            while (true)
            {
                Thread.Sleep(3000);
                BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                buffer.Seek(0);
                ushort constant_out = 1007;
                buffer.Write(constant_out);
                SendToAllClients(buffer);
            }
        }

        /// <summary>
        /// Sends a message out to all connected clients.
        /// </summary>
        public void SendToAllClients(BufferStream buffer)
        {
            foreach (SocketHelper client in Clients)
            {
                client.SendMessage(buffer);
            }
        }

        /// <summary>
        /// Sends a message out all clients in a lobby.
        /// </summary>
        public void SendToLobby(Lobby lobby, BufferStream buffer)
        {
            foreach (SocketHelper client in lobby.LobbyClients)
            {
                client.SendMessage(buffer);
            }
        }

        /// <summary>
        /// Listens for clients and starts threads to handle them.
        /// </summary>
        private void Listen(int port)
        {
            TCPListener = new TcpListener(IPAddress.Any, port);
            TCPListener.Start();

            while (true)
            {
                Thread.Sleep(10);
                TcpClient tcpClient = TCPListener.AcceptTcpClient();
                Console.WriteLine("New client detected. Connecting client.");
                SocketHelper helper = new SocketHelper();
                helper.StartClient(tcpClient, this);
                Clients.Add(helper);
            }
        }

        /// <summary>
        /// Handles matchmaking between clients searching for games.
        /// </summary>
        public void Matchmaking()
        {
            while (true)
            {
                Thread.Sleep(10);
                bool match_made = false;
                bool should_break = false;
                SocketHelper client_to_remove_1 = null;
                SocketHelper client_to_remove_2 = null;

                //Finds a match for clients.
                foreach (SocketHelper client1 in SearchingClients)
                {
                    //Finds a match for clients.
                    foreach (SocketHelper client2 in SearchingClients)
                    {
                        if (client1.ClientName != client2.ClientName)
                        {
                            //Randomily selects a map for matchmaking.
                            Random random = new Random();
                            int index = random.Next(0, Maps.Length);
                            string map = Maps[index];

                            //Create a lobby.
                            Lobby lobby = new Lobby();
                            lobby.SetupLobby(map, client1, client2);
                            Lobbies.Add(lobby);

                            //Remove clients from searching list.
                            client1.IsSearching = false;
                            client2.IsSearching = false;
                            client_to_remove_1 = client1;
                            client_to_remove_2 = client2;
                            should_break = true;
                            match_made = true;

                            //Send start game to clients.
                            BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                            buffer.Seek(0);
                            UInt16 constant = 1003;
                            string send_map = map;
                            string name_1 = client1.ClientName;
                            string name_2 = client2.ClientName;
                            string race_1 = client1.ClientRace;
                            string race_2 = client2.ClientRace;
                            UInt16 number_1 = (UInt16)client1.ClientNumber;
                            UInt16 number_2 = (UInt16)client2.ClientNumber;
                            buffer.Write(constant);
                            buffer.Write(send_map);
                            buffer.Write(name_1);
                            buffer.Write(name_2);
                            buffer.Write(race_1);
                            buffer.Write(race_2);
                            buffer.Write(number_1);
                            buffer.Write(number_2);
                            SendToLobby(lobby, buffer);
                            Console.WriteLine("Matchmade between " + name_1 + " and " + name_2 + " on " + send_map);
                            break;
                        }
                    }

                    //Check if match have been made.
                    if (should_break)
                    {
                        break;
                    }
                }

                //Check if match was made.
                if (match_made)
                {
                    SearchingClients.Remove(client_to_remove_1);
                    SearchingClients.Remove(client_to_remove_2);
                }
            }
        }

        /// <summary>
        /// Handles sessions of clients.
        /// </summary>
        public class Lobby
        {
            public List<SocketHelper> LobbyClients;
            public String Map;

            /// <summary>
            /// Adds two clients and the map to the lobby from matchmaking.
            /// </summary>
            public void SetupLobby(String map, SocketHelper player1, SocketHelper player2)
            {
                LobbyClients = new List<SocketHelper>();
                LobbyClients.Add(player1);
                LobbyClients.Add(player2);
                player1.GameLobby = this;
                player2.GameLobby = this;
                player1.ClientNumber = 1;
                player2.ClientNumber = 2;
                player1.IsIngame = true;
                player2.IsIngame = true;
                this.Map = map;
            }
        }

        /// <summary>
        /// Handles clients. Reads and writes data and stores client information.
        /// </summary>
        public class SocketHelper
        {
            Queue<BufferStream> WriteQueue = new Queue<BufferStream>();
            public Thread ReadThread;
            public Thread WriteThread;
            public Thread AbortThread;
            public TcpClient MscClient;
            public Server ParentServer;
            public string ClientIPAddress;
            public string ClientName;
            public string ClientRace;
            public int ClientNumber;
            public Lobby GameLobby;
            public bool IsSearching;
            public bool IsIngame;

            /// <summary>
            /// Starts the given client in two threads for reading and writing.
            /// </summary>
            public void StartClient(TcpClient client, Server server)
            {
                //Sets client variable.
                MscClient = client;
                MscClient.SendBufferSize = BufferSize;
                MscClient.ReceiveBufferSize = BufferSize;
                ParentServer = server;

                //Starts a read thread.
                ReadThread = new Thread(new ThreadStart(delegate
                {
                    Read(client);
                }));
                ReadThread.Start();
                Console.WriteLine("Client read thread started.");

                //Starts a write thread.
                WriteThread = new Thread(new ThreadStart(delegate
                {
                    Write(client);
                }));
                WriteThread.Start();
                Console.WriteLine("Client write thread started.");
            }

            /// <summary>
            /// Sends a string message to the client. This message is added to the write queue and send
            /// once it is it's turn. This ensures all messages are send in order they are given.
            /// </summary>
            public void SendMessage(BufferStream buffer)
            {
                WriteQueue.Enqueue(buffer);
            }

            /// <summary>
            /// Disconnects the client from the server and stops all threads for client.
            /// </summary>
            public void DisconnectClient()
            {
                //Console Message.
                Console.WriteLine("Disconnecting: " + ClientIPAddress);

                //Check if client is ingame.
                if (IsIngame)
                {
                    //Find opposing client.
                    SocketHelper opponet = null;
                    foreach (SocketHelper lobbyClient in GameLobby.LobbyClients)
                    {
                        if (lobbyClient != this)
                        {
                            opponet = lobbyClient;
                        }
                    }

                    //Causes opponent to win.
                    BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                    buffer.Seek(0);
                    UInt16 constant_out = 1010;
                    buffer.Write(constant_out);
                    opponet.SendMessage(buffer);
                    Console.WriteLine(ClientIPAddress + " is ingame. Granting win to opponent.");

                    //Remove lobby from server.
                    ParentServer.Lobbies.Remove(GameLobby);
                    GameLobby = null;
                    IsIngame = false;
                }

                //Removes client from server.
                ParentServer.Clients.Remove(this);
                if (IsSearching)
                {
                    Console.WriteLine(ClientIPAddress + " was searching for a game. Stopped searching.");
                    ParentServer.SearchingClients.Remove(this);
                    IsSearching = false;
                }

                //Closes Stream.
                MscClient.Close();

                //Starts an abort thread.
                AbortThread = new Thread(new ThreadStart(delegate
                {
                    Abort();
                }));
                Console.WriteLine("Aborting threads on client.");
                AbortThread.Start();
            }

            /// <summary>
            /// Handles aborting of threads.
            /// </summary>
            public void Abort()
            {
                //Stops Threads
                ReadThread.Abort();
                Console.WriteLine("Read thread aborted on client.");
                WriteThread.Abort();
                Console.WriteLine("Write thread aborted on client.");
                Console.WriteLine(ClientIPAddress + " disconnected.");
                Console.WriteLine(Convert.ToString(ParentServer.Clients.Count) + " clients online.");
                AbortThread.Abort();
            }

            /// <summary>
            /// Writes data to the client in sequence on the server.
            /// </summary>
            public void Write(TcpClient client)
            {
                while (true)
                {
                    Thread.Sleep(10);
                    if (WriteQueue.Count != 0)
                    {
                        try
                        {
                            BufferStream buffer = WriteQueue.Dequeue();
                            NetworkStream stream = client.GetStream();
                            stream.Write(buffer.Memory, 0, buffer.Iterator);
                            stream.Flush();
                        }
                        catch (System.IO.IOException)
                        {
                            DisconnectClient();
                            break;
                        }
                        catch (NullReferenceException)
                        {
                            DisconnectClient();
                            break;
                        }
                        catch (ObjectDisposedException)
                        {
                            //Do nothing - client is already disconnecting.
                            break;
                        }
                        catch (System.InvalidOperationException)
                        {
                            //Do nothing - client is already disconnecting.
                            break;
                        }
                    }
                }
            }

            /// <summary>
            /// Reads data from the client and sends back a response.
            /// </summary>
            public void Read(TcpClient client)
            {
                while (true)
                {
                    try
                    {
                        Thread.Sleep(10);
                        BufferStream readBuffer = new BufferStream(BufferSize, 1);
                        NetworkStream stream = client.GetStream();
                        stream.Read(readBuffer.Memory, 0, BufferSize);

                        //Read the header data.
                        ushort constant;
                        readBuffer.Read(out constant);

                        //Determine input commmand.
                        switch (constant)
                        {
                            //New Connection
                            case 2000:
                                {
                                    //Read out client data.
                                    String ip;
                                    readBuffer.Read(out ip);

                                    //Update client information.
                                    ClientIPAddress = ip;

                                    //Console Message.
                                    Console.WriteLine(ip + " connected.");
                                    Console.WriteLine(Convert.ToString(ParentServer.Clients.Count) + " clients online.");
                                    break;
                                }

                            //Find Game
                            case 2001:
                                {
                                    //Read out client data.
                                    String ip;
                                    String name;
                                    String race;
                                    readBuffer.Read(out ip);
                                    readBuffer.Read(out name);
                                    readBuffer.Read(out race);

                                    //Update client information.
                                    ClientIPAddress = ip;
                                    ClientName = name;
                                    ClientRace = race;
                                    IsSearching = true;
                                    IsIngame = false;

                                    //Add client to searching clients.
                                    ParentServer.SearchingClients.Add(this);
                                    Console.WriteLine(ip + " is searching for a game as " + race + " under the name " + name);
                                    break;
                                }

                            //Cancel Find Game
                            case 2002:
                                {
                                    //Read out client data.
                                    String ip;
                                    readBuffer.Read(out ip);

                                    //Update client information.
                                    IsSearching = false;

                                    //Removes client from searching list.
                                    ParentServer.SearchingClients.Remove(this);
                                    Console.WriteLine(ip + " stopped searching.");
                                    break;
                                }

                            //Recive Move Input
                            case 2003:
                                {
                                    //Read buffer data.
                                    String name;
                                    UInt32 input;
                                    UInt16 xx;
                                    UInt16 yy;
                                    readBuffer.Read(out name);
                                    readBuffer.Read(out input);
                                    readBuffer.Read(out xx);
                                    readBuffer.Read(out yy);

                                    //Send start game to clients.
                                    BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                                    buffer.Seek(0);
                                    UInt16 constant_out = 1004;
                                    buffer.Write(constant_out);
                                    buffer.Write(name);
                                    buffer.Write(input);
                                    buffer.Write(xx);
                                    buffer.Write(yy);
                                    ParentServer.SendToLobby(GameLobby, buffer);
                                    Console.WriteLine("Recived input at " + Convert.ToString(xx) + "," + Convert.ToString(yy) + " from " + ClientIPAddress);
                                    break;
                                }

                            //Recive client ping.
                            case 2004:
                                {
                                    //Send ping return to client.
                                    BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                                    buffer.Seek(0);
                                    UInt16 constant_out = 1050;
                                    buffer.Write(constant_out);
                                    SendMessage(buffer);
                                    break;
                                }

                            //Recive server ping.
                            case 2005:
                                {
                                    //Nothing - Ping handled in ping thread.
                                    break;
                                }

                            //Recive matchmaking players request.
                            case 2006:
                                {
                                    //Send players online return to client.
                                    BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                                    buffer.Seek(0);
                                    UInt16 constant_out = 1008;
                                    int players_online = ParentServer.Clients.Count;
                                    buffer.Write(constant_out);
                                    buffer.Write(players_online);
                                    SendMessage(buffer);
                                    break;
                                }

                            // 7 = Recive End Turn
                            case 2007:
                                {
                                    //Send end turn input to clients.
                                    BufferStream buffer = new BufferStream(BufferSize, BufferAlignment);
                                    buffer.Seek(0);
                                    UInt16 constant_out = 1006;
                                    buffer.Write(constant_out);
                                    ParentServer.SendToLobby(GameLobby, buffer);
                                    Console.WriteLine("Recived end turn from " + ClientIPAddress);
                                    break;
                                }
                        }
                    }
                    catch (System.IO.IOException)
                    {
                        DisconnectClient();
                        break;
                    }
                    catch (NullReferenceException)
                    {
                        DisconnectClient();
                        break;
                    }
                    catch (ObjectDisposedException)
                    {
                        //Do nothing - client is already disconnecting.
                        break;
                    }
                    catch (System.InvalidOperationException)
                    {
                        //Do nothing - client is already disconnecting.
                        break;
                    }
                }
            }
        }
    }
}