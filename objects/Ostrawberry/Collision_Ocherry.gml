with(Ocherry)
{
    // Destroy any existing strawberry follower if it's fading
    if (instance_exists(follow_strawberry) && follow_strawberry.image_alpha < 1) {
        with (follow_strawberry) instance_destroy();
        follow_strawberry = noone;
        strawberryF = noone;
    }
    // If a banana follower is fading, destroy it immediately
    if (instance_exists(follow_banana) && follow_banana.image_alpha < 1) {
        with (follow_banana) instance_destroy();
        follow_banana = noone;
        bananaF = noone;
    }
    if(Jcount == 0) Jmax = 2; addS = true;
    if(Jcount == Jmax) Jmax++; addS = true;
    if(!canDJ) canDJ = true;
}
audio_sound_pitch(SNfruit,random_range(0.8,1.3));
audio_play_sound(SNfruit,5,false);
instance_destroy();
repeat (5)
{
	instance_create_layer(x,y,"powerups",Odust)
}
if(half)
{
	with(instance_create_layer(x,y,layer,OstrawberryC)) half = true;
}
else
{
	instance_create_layer(x,y,layer,OstrawberryC);
}
