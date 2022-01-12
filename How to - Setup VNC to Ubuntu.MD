To remote into the GUI on an Ubuntu instance, you need to start off by enabling some features and installing Vino, below we'll go through the steps to enable this.

This document has been sourced from LinuxHint and consolidated here for ease of access, if you'd like to visit the original document, please click the link below.
Source: https://linuxhint.com/enable-screen-sharing-ubuntu/

Installing VNC Server on Ubuntu 20.04 LTS:
This article will use the GNOME desktop environment’s built-in Screen Sharing feature to access the Ubuntu 20.04 LTS graphical desktop environment remotely. The GNOME desktop environment uses the Vino VNC server to implement the Screen Sharing function.

The Vino VNC server might not be installed on your Ubuntu 20.04 LTS operating system by default. But it is available in the official package repository of Ubuntu 20.04 LTS. So, you can install it easily.

First, update the APT package repository cache with the following command:

$ sudo apt update

![image](https://user-images.githubusercontent.com/15055337/149156134-48228fce-cd92-4342-8d0b-42aee544f1e7.png)


The APT package repository cache should be updated.

![image](https://user-images.githubusercontent.com/15055337/149156152-f9c32b47-e5dc-4ab9-ab85-c60b5c26da4d.png)

To install Vino, run the following command:

$ sudo apt install vino

![image](https://user-images.githubusercontent.com/15055337/149156173-4ddb6613-7e24-474e-bc64-300420743f74.png)

To confirm the installation, press Y and then press <Enter>.

![image](https://user-images.githubusercontent.com/15055337/149156199-d643a20c-2ce7-47c7-b651-d78c87d59eed.png)

Vino should be installed.
  
![image](https://user-images.githubusercontent.com/15055337/149156216-20064abe-6377-4052-9dbf-0e7a2c149ee4.png)


Enable Screen Sharing on Ubuntu 20.04 LTS:
  
Once you have vino installed, you can enable Screen Sharing from the Settings app.

Open the Settings app from the Application Menu of Ubuntu 20.04 LTS.

![image](https://user-images.githubusercontent.com/15055337/149156249-19c5cdc5-e439-45cc-9adf-12fec16edaa3.png)

 
Navigate to Sharing section and click on the toggle button as marked in the screenshot below to enable Sharing.

![image](https://user-images.githubusercontent.com/15055337/149156262-3684e632-3ed5-48e4-8433-7f61fd2fcb70.png)

Once Sharing is enabled, click on Screen Sharing as marked in the screenshot below.

![image](https://user-images.githubusercontent.com/15055337/149156288-609ccb82-b275-4924-90b2-5f30ac5ae7d9.png)

From the Screen Sharing window, click on the toggle button as marked in the screenshot below to enable Screen Sharing.

![image](https://user-images.githubusercontent.com/15055337/149156323-4b1d2fbe-f8ef-4b8c-a82e-6c193032930b.png)

Screen Sharing should be enabled.

![image](https://user-images.githubusercontent.com/15055337/149156392-a31c043f-8b27-4707-8ffb-aeebb8c3e608.png)

From the Access Options section, you can configure authentication methods for your VNC server.

New connections must ask for access: This is the default authentication method. When this authentication method is selected, you will get a prompt message every time a remote VNC client tries to access your computer. If you allow access to your computer, only then the remote VNC client can access your computer.

Require a password: In this method, you can set a password for the VNC server. The remote VNC client must enter the password to access your computer.

![image](https://user-images.githubusercontent.com/15055337/149156413-bc44954b-65be-4c84-99a9-6f03f6a1a052.png)


I prefer the password authentication method. So, I will set password authentication for the VNC server in this article.

To set a password for your VNC server, select Require a password from the Access Options section and type in your desired password in the Password textbox as marked in the screenshot below.

 ![image](https://user-images.githubusercontent.com/15055337/149156567-a205c18a-d484-400e-aa87-2a00f2b4a995.png)


Finding the IP Address of Your Computer:
Once you have Screen Sharing enabled, the person who wants to connect to your computer remotely needs to know your computer’s IP address.

You can find the IP address of your computer with the following command:

$ hostname -I

  ![image](https://user-images.githubusercontent.com/15055337/149156578-1f72ec93-33d1-4df2-90a3-f5d92db84aa6.png)

The IP address of my computer is 192.168.20.131. It will be different for you. So, make sure to replace it with yours from now on.

![image](https://user-images.githubusercontent.com/15055337/149156592-34dde23e-b989-48d1-b6db-e723e7439ad0.png)
  
 End of Guide.
  
 Final Steps:
  VNC may actively refuse the connection to your instance. If this is happening, run the following command (NOT AS SUDO)
  
  $ gsettings set org.gnome.Vino require-encryption false
  
  This should make VNC not require encryption to connect and it'll allow your VNC session. 
