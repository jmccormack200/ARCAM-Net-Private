#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h> /* for strncpy */

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <arpa/inet.h>


#define GNU_RADIO
#define BATMAN

#define SDR_RunScript "../Flowgraphs/broadcastwithFreqNoMac.py"
#define mesh_RunScript "raiseTheBatSignal.sh"
#define txGainStart "45"
#define rxGainStart "45"


void check(int result);
char * getIP();

int main (int argn, const char * argv[])
{ 
		if (argn < 2) check (-1);
		//arguments
		const char * password = argv[1];
		
        int ret;


        //for injecting pasword for rebroot permissions
        char passInject[20];
        strcpy(passInject, "echo ");
        strcat(passInject, password);
        strcat(passInject, " | sudo -S ");

        //comand arguments
        char command[50];

        #ifdef GNU_RADIO

        printf("Loading GNU RADIO blocks... %s\n", SDR_RunScript);

        strcpy(command, passInject);
        strcat(command, "python ");
        strcat(command, SDR_RunScript);
        strcat(command, " --tx-gain ");
        strcat(command, txGainStart);
        strcat(command, " --rx-gain ");
        strcat(command, rxGainStart);
        

        //"echo $PASS | sudo -S python $SDR_RunScript --tx-gain 45 --rx-gain 45"
        ret = system (command);
        //ret = system("&"); //send process to background
        check(ret);	

        printf("DONE\n");

        wait(10);
        
        #endif

        #ifdef BATMAN

        printf("Running BATMAN scripts... %s\n",mesh_RunScript);

        strcpy(command, passInject);
        strcat(command, "bash ");
        strcat(command, mesh_RunScript);

		//"echo $PASS | sudo -S sh $mesh_RunScript"
        ret = system (command);

		wait();
		check(ret);

		//setIP

		printf("Loading IP from eth0...\n");

        char* eth0IP = getIP();
        char last3 [3];
        strncmp(eth0IP, last3, 12);

        char batIP [15];
        strcpy(batIP, "192.168.200.");
        strcat(batIP, last3);

        strcpy(command, passInject);
        strcat(command, "ifconfig bat0 ");
        strcat(command, batIP);



        //"echo $PASS | sudo -S ifconfig bat0 192.168.200.$last3of eth0"
        ret = system(command);
        check (ret);

        printf("Ip set to %s\n",batIP);


        printf("Starting BATCTL monitor...\n");

		strcpy(command, passInject);
        strcat(command, "batctl o -w");
        //echo $PASS | sudo -S batctl o -w"
        ret = system(command);
        #endif

        return 0;
}

void check(int result)
{
	if (result < 0)
	{
		printf("Error was thrown!!!!!!\n");
		exit(1);
	}
}

char * getIP ()
{
	int fd;
	struct ifreq ifr;

	fd = socket(AF_INET, SOCK_DGRAM, 0);

	/* I want to get an IPv4 IP address */
	ifr.ifr_addr.sa_family = AF_INET;

	/* I want IP address attached to "eth0" */
	strncpy(ifr.ifr_name, "eth0", IFNAMSIZ-1);

	ioctl(fd, SIOCGIFADDR, &ifr);

	close(fd);

	/* display result */
	return inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr);
}