import processing.sound.*;

SoundFile file;

String audioName = "TNTSong.mp3";

String path;

void setup()
{
    path = sketchPath(audioName);
    file = new SoundFile(this, path);
    file.play();
}
