force = random_range(5,10)
spd.x = choose(force,-force);
spd.y = choose(force,-force);
hitstun = ceil(max(abs(spd.x),abs(spd.y) * 5));