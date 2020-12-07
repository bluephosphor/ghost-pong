/// @description matchmaking request timeout
if (matchmaking_request >= 0) exit;

matchmaking_connected = false;
log("matchmaking server connection failed. it may be offline. direct connection still available.");
room_goto(R_SERVER);