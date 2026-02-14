face = 1;
flip = true;

// LEVEL SYSTEM
level_upgrade = 0; // Bonus levels this enemy gives when room is cleared

side = "noone";
//shuild
instance_create_layer(x,y,"powerups",Oshuild);


charge = false
chargeTime = 35;
chargeTimer = chargeTime;
chargingTime = 60;
charging = chargingTime;

chargeDirection = 0;
diraction = false;

shuild = true;

colddown = false;
colddownTimer = 45;
colddownTime = colddownTimer;

sound_circle = true;
sound_charge = true;
sound_waind  = true