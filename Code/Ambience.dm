#define AMBIENCEVOLUME 100
#define SFXABM
#define AMB

area/hogwarts/hogwartsambienttrigger
	Entered(Q)
		if(prob(20))
			Q << pick('ambicha1.ogg','ambicha2.ogg','ambicha3.ogg','ambicha4.ogg')


