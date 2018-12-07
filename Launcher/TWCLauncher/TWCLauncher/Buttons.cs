using System;
using System.Net;
using System.Diagnostics;

namespace TWCLauncher
{
    class Buttons
    {
        public static string MainServerIP; //The server IP is always on github as a editable txt file so users won't have to update their launchers everytime a new main server IP comes up
        public static string HUBLink = "http://www.byond.com/games/TheWizardsChronicles/TWC";
        public static string UpdateLink = "https://github.com/MaxIsJoe/TWC/releases";


        private static MainWindow MW = new MainWindow();
        private static bool upDate = MW.UpToDate; //Only did this because i thought it made things look cleaner

        public static void ManualConnectPage()
        {
            var Manual = new ManualWin();
            Manual.Show();
        }
        public static void MainServerConnect()
        {
            if (upDate != true)
            {
                Process.Start(UpdateLink); //Redirects the users to where the new launcher can be downloaded.
            }
            else
            {
                MainServerIP = new WebClient().DownloadString("https://raw.githubusercontent.com/MaxIsJoe/TWC/MIJ-HostVer/Launcher/TWCLauncher/mainserver.txt");
                MainServerIP.Replace("\n", "");
                Process.Start("byondfiles\\dreamseeker.exe", MainServerIP);
            }
        }
        public static void OpenHUB()
        {
            Process.Start(HUBLink); //Opens up the HUB
        }
        
    }
}
