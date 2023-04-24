# Customize GDM Background for Pop!_OS 22.04 Jammy Jellyfish

Linux always offers a way to overcome obstacles. With its dynamic nature, the concept of a restricted environment for users doesn't hinder adaptability. As a Pop!_OS user, I've become accustomed to the brown GDM login screen as an integral aspect of the OS. Although it's not terrible, it's not the most attractive color and offers no alternatives.

I was thrilled to discover a script on GitHub that claimed to modify the GDM theme (image, color, or gradient), thanks to UbuntuHandbook's team who shared the news about this excellent script by Pratak Kumar. The author emphasized that the script was designed exclusively for Ubuntu and included a test for that condition.

Unlike many people, I make sure scripts produce only the desired outcome by using my Crash Test VM for all scripting tasks. I carefully analyze any changes when I come across something intriguing that can bring joy. I strongly discourage running scripts without a sandbox or crash test machine, just as with modifying kernels or untrusted sources.

Nonetheless, you can dissect and examine a script because its source is accessible and editable as needed. If you're unsure about a script's functionality, avoid using it. Seriously.

Below is my customized script for setting the GDM Background on Pop!_OS 22.04 Jammy Jellyfish. I tweaked the script, tested it, and it works great for me.

## What not to expect

This will not alter the drive encryption screen's background. I have no desire for that to occur.

## What to expect

This enables you to change the default GDM login screen to your preference. When using a background image, I recommend a fixed path to a locally stored image to prevent issues. Relative paths or remote images won't work and may result in a broken login screen.

The script requires sudo privileges (never run anything as root, right?) and should be thoroughly examined to understand the options and recovery process. The primary distinction is that you're invoking the `pop-gdm-set-background` script, NOT `ubuntu-gdm-set-background`. I have written this exclusively for Pop!_OS 22.04, but you can adapt it for other releases if desired.

Apologies for the delayed response – work sometimes takes precedence. This is a bash script. Copy the script and name it as you wish. For simplicity, let's call it `mybackground.sh`. Store it in your script directory. Make it executable:

```bash
chmod 700 popgmdchanger.sh
```
Then execute it with sudo privileges:

```bash
sudo ./popgmdchanger.sh --image /PATH/TO/YOUR/IMAGE
```
Where --image /PATH/TO/YOUR/IMAGE is the chosen image.

## Using a Blurred Image as GDM Background

### If you prefer a blurred picture for your GDM background, the most efficient method is to select an image and then blur it using the Lunapic website. Follow these steps:

1. Visit [Lunapic](https://www2.lunapic.com/editor/?action=blur) to access their online image editor.
2. Upload your chosen image.
3. Apply the blur effect as desired.
4. Save the blurred image to your computer.

Once you have the blurred image, you can set it as your GDM background using the script as described earlier.

```bash
sudo ./popgmdchanger.sh --image /PATH/TO/YOUR/BLURRED/IMAGE
```


