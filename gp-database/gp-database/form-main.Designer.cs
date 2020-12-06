namespace gp_database
{
    partial class FormMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.gpDataSet = new gp_database.gpDataSet();
            this.lbl_clients = new System.Windows.Forms.Label();
            this.list_box_clients = new System.Windows.Forms.ListBox();
            this.list_box_servers = new System.Windows.Forms.ListBox();
            this.lbl_servers = new System.Windows.Forms.Label();
            this.btn_add_client = new System.Windows.Forms.Button();
            this.txt_client_name = new System.Windows.Forms.TextBox();
            this.btn_update = new System.Windows.Forms.Button();
            this.btn_delete_client = new System.Windows.Forms.Button();
            this.list_log = new System.Windows.Forms.ListBox();
            ((System.ComponentModel.ISupportInitialize)(this.gpDataSet)).BeginInit();
            this.SuspendLayout();
            // 
            // gpDataSet
            // 
            this.gpDataSet.DataSetName = "gpDataSet";
            this.gpDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // lbl_clients
            // 
            this.lbl_clients.AutoSize = true;
            this.lbl_clients.Location = new System.Drawing.Point(13, 64);
            this.lbl_clients.Name = "lbl_clients";
            this.lbl_clients.Size = new System.Drawing.Size(38, 13);
            this.lbl_clients.TabIndex = 0;
            this.lbl_clients.Text = "Clients";
            // 
            // list_box_clients
            // 
            this.list_box_clients.FormattingEnabled = true;
            this.list_box_clients.Location = new System.Drawing.Point(12, 81);
            this.list_box_clients.Name = "list_box_clients";
            this.list_box_clients.Size = new System.Drawing.Size(120, 199);
            this.list_box_clients.TabIndex = 1;
            this.list_box_clients.SelectedIndexChanged += new System.EventHandler(this.list_box_clients_SelectedIndexChanged);
            // 
            // list_box_servers
            // 
            this.list_box_servers.FormattingEnabled = true;
            this.list_box_servers.Location = new System.Drawing.Point(139, 81);
            this.list_box_servers.Name = "list_box_servers";
            this.list_box_servers.Size = new System.Drawing.Size(120, 199);
            this.list_box_servers.TabIndex = 3;
            // 
            // lbl_servers
            // 
            this.lbl_servers.AutoSize = true;
            this.lbl_servers.Location = new System.Drawing.Point(139, 64);
            this.lbl_servers.Name = "lbl_servers";
            this.lbl_servers.Size = new System.Drawing.Size(43, 13);
            this.lbl_servers.TabIndex = 2;
            this.lbl_servers.Text = "Servers";
            // 
            // btn_add_client
            // 
            this.btn_add_client.Location = new System.Drawing.Point(16, 38);
            this.btn_add_client.Name = "btn_add_client";
            this.btn_add_client.Size = new System.Drawing.Size(75, 23);
            this.btn_add_client.TabIndex = 4;
            this.btn_add_client.Text = "Add Client";
            this.btn_add_client.UseVisualStyleBackColor = true;
            this.btn_add_client.Click += new System.EventHandler(this.btn_add_client_Click);
            // 
            // txt_client_name
            // 
            this.txt_client_name.Location = new System.Drawing.Point(12, 12);
            this.txt_client_name.Name = "txt_client_name";
            this.txt_client_name.Size = new System.Drawing.Size(247, 20);
            this.txt_client_name.TabIndex = 5;
            // 
            // btn_update
            // 
            this.btn_update.Location = new System.Drawing.Point(97, 38);
            this.btn_update.Name = "btn_update";
            this.btn_update.Size = new System.Drawing.Size(75, 23);
            this.btn_update.TabIndex = 6;
            this.btn_update.Text = "Update Client";
            this.btn_update.UseVisualStyleBackColor = true;
            this.btn_update.Click += new System.EventHandler(this.btn_update_Click);
            // 
            // btn_delete_client
            // 
            this.btn_delete_client.Location = new System.Drawing.Point(179, 38);
            this.btn_delete_client.Name = "btn_delete_client";
            this.btn_delete_client.Size = new System.Drawing.Size(75, 23);
            this.btn_delete_client.TabIndex = 7;
            this.btn_delete_client.Text = "Remove Client";
            this.btn_delete_client.UseVisualStyleBackColor = true;
            this.btn_delete_client.Click += new System.EventHandler(this.btn_delete_client_Click);
            // 
            // list_log
            // 
            this.list_log.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.list_log.BackColor = System.Drawing.SystemColors.WindowText;
            this.list_log.ForeColor = System.Drawing.SystemColors.Window;
            this.list_log.FormattingEnabled = true;
            this.list_log.Location = new System.Drawing.Point(266, 16);
            this.list_log.Name = "list_log";
            this.list_log.Size = new System.Drawing.Size(245, 264);
            this.list_log.TabIndex = 8;
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Window;
            this.ClientSize = new System.Drawing.Size(523, 286);
            this.Controls.Add(this.list_log);
            this.Controls.Add(this.btn_delete_client);
            this.Controls.Add(this.btn_update);
            this.Controls.Add(this.txt_client_name);
            this.Controls.Add(this.btn_add_client);
            this.Controls.Add(this.list_box_servers);
            this.Controls.Add(this.lbl_servers);
            this.Controls.Add(this.list_box_clients);
            this.Controls.Add(this.lbl_clients);
            this.Name = "FormMain";
            this.Text = "gp-master";
            this.Load += new System.EventHandler(this.FormMain_Load);
            ((System.ComponentModel.ISupportInitialize)(this.gpDataSet)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private gpDataSet gpDataSet;
        private System.Windows.Forms.Label lbl_clients;
        private System.Windows.Forms.ListBox list_box_clients;
        private System.Windows.Forms.ListBox list_box_servers;
        private System.Windows.Forms.Label lbl_servers;
        private System.Windows.Forms.Button btn_add_client;
        private System.Windows.Forms.TextBox txt_client_name;
        private System.Windows.Forms.Button btn_update;
        private System.Windows.Forms.Button btn_delete_client;
        private System.Windows.Forms.ListBox list_log;
    }
}

