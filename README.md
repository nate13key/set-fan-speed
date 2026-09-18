This is a simple bash script that sets the fan speed of an IPMI server. 

Before using this script, be sure to rename .env.example to .env and update the values of each variable to match your environment. You can use this command:

mv .env.example .env


# TODO: 
Maybe I could add a flag to watch temps by using something like this:

ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" sdr type temperature

Then I could take the max of those numbers and echo to STDOUT. 

Then I could make a chron job to monitor the temps and if the temps get too high, just revert to automatic control. 
