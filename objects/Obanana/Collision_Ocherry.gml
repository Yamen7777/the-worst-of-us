with(Ocherry)
{
    // Destroy any existing banana follower if it's fading
    if (instance_exists(follow_banana) && follow_banana.image_alpha < 1) {
        with (follow_banana) instance_destroy();
        follow_banana = noone;
        bananaF = noone;
    }
    // If a strawberry follower is fading, destroy it immediately
    if (instance_exists(follow_strawberry) && follow_strawberry.image_alpha < 1) {
        with (follow_strawberry) instance_destroy();
        follow_strawberry = noone;
        strawberryF = noone;
    }
    canDash = true;
}
audio_sound_pitch(SNfruit,random_range(0.8,1.3));
audio_play_sound(SNfruit,5,false);
instance_destroy();
repeat (5)
{
	instance_create_layer(x,y,"powerups",Odust)
}
instance_create_layer(x,y,layer,ObananaC);
