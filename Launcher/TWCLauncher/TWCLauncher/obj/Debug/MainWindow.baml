   M S B A M L   `   `   `  ����F  BTWCLauncher, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null)clr-namespace:TWCLauncherTWCLauncher  5   	       TWCLauncher.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   +localclr-namespace:TWCLauncher     5   	   -   5          �Name$  MAINEE��5   	    � Title$ TWC Launcher��5   	   $��536.868��6   $��986.511��6/    � 
ResizeMode$ NoResize=�6?   ��5	      �� 5
   
    �� EndPoint$ 0.5,1&�6    �� 
StartPoint$ 0.5,0&�6/   .��5      �  � Color$ Black��6    � Offset$ 0.852Q�6)   � 5      $ 	#FF646464��6   $ 1Q�6-   5      .��5      � -   5         �Name$ MAINP��5       � ColumnDefinitions 5   
   �� 5      $	��17* �6   �� 5      $
��405* �6   .+�5   
    � -   5        	  �Name$	 MyFrame��5      $�� ��6!   $
��Left=�6,   $	��499��6G   $	��Top=�6T   $	��971��6l   
 J� RenderTransformOrigin$
 0.506,0.541&�6x   $��2��6�   �� 5   
   -   5         ��Name$ 
PlayButton��5      $
��Play��6%   $
��Left=�64   $��395,446,0,0q�6O   $	��Top=�6d   $	��116��6|   4  .System.Windows.Automation.AutomationProperties   Name$ 
TestButton��6�   $��49��6�   $
��Bold"�6�   $��Expanded&�6�   $��16(�6�   ���	#FFECECEC
���   ����	#FF4F4F4F$��1��6M  �� 5   
   -   5        $��Connect to other Servers��5      $
��Left=�64   $��516,469,0,0q�6O   $	��Top=�6d   $	��143��6|   $��1��6�   �� 5   
   -   5        $��Connect Manually��5      $
��Left=�6,   $��247,471,0,0q�6G   $	��Top=�6\   $	��143��6t   $��1��6�   (  "System.Windows.Controls.WebBrowser  5   
   -   5          Name$ browser��5      $
��Left=�6&   $	��431��6A   $��	10,10,0,0q�6N   $	��Top=�6a   $	��961��6y      Source$! https://twcgame.tumblr.com/?�6�   $��2��6�   �� 5   
   -   5         ��Name$ VersionLabel��5      $��Version : 0.0��6&   $
��Left=�6>   $��773,469,0,0q�6Y   $	��Top=�6n   $	��158��6�   
�������$��1��6�   5      5      