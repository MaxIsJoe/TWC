using System;
using System.Windows;
using System.Windows.Media;
using System.Net;

namespace TWCLauncher
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        public string version = "0.2\n"; //Launcher Version
        public bool UpToDate; //Is the Launcher up to date?
        private string fileContent;

        public MainWindow()
        {
            InitializeComponent();
            SizeToContent = SizeToContent.WidthAndHeight;
            fileContent = new WebClient().DownloadString("https://raw.githubusercontent.com/MaxIsJoe/TWC/MIJ-HostVer/Launcher/TWCLauncher/version.txt"); //Checks if there's a new version or not
            VersionLabel.Content = ("Launcher Version : " + version);
            if(fileContent != version) //If there is or isn't a new update do the following
            {
                UpToDate = false;
                PlayButton.Content = "Update";
                VersionLabel.Foreground = Brushes.Red; //Tells users that their launcher is outdated.
            }
            else
            {
                UpToDate = true;
                PlayButton.Content = "Play";
            }
            //Console.Out.WriteLine(UpToDate);
            //Console.Out.WriteLine(fileContent);
        }

        private void CTOSB_Click_1(object sender, RoutedEventArgs e)
        {
            Buttons.OpenHUB();
        }

        private void CMB_Click(object sender, RoutedEventArgs e)
        {
            Buttons.ManualConnectPage();
        }

        private void TestButton_Click(object sender, RoutedEventArgs e)
        {
            Buttons.MainServerConnect();
        }

        private void ProgressBar_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {

        }
    }
}
