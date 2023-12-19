# Personalize GDM Background for Pop!_OS 22.04 Jammy Jellyfish

Linux's flexibility consistently paves the way to surmount challenges. As an avid Pop!_OS user, the standard brown GDM login screen has become a familiar part of the OS. Although it's not distasteful, the color could be more appealing, and the absence of alternatives is noticeable.

Fortunately, I found a script on GitHub, courtesy of UbuntuHandbook's team, developed by Pratak Kumar, which allows you to modify the GDM theme (image, color, or gradient). The script was initially intended for Ubuntu, and a corresponding compatibility check was included.

To ensure that scripts operate as expected, I use my Crash Test VM for all scripting tasks. It is my practice to analyze any alterations meticulously whenever I come across something potentially beneficial. It is advisable to refrain from executing scripts without a sandbox or crash test environment, especially when meddling with kernels or untrusted sources.

However, you have the freedom to inspect and edit a script because its source code is available and modifiable as needed. If you're uncertain about a script's operation, it's best to refrain from using it.

Presented below is my personalized script for changing the GDM Background on Pop!_OS 22.04 Jammy Jellyfish. After fine-tuning and testing, the script works perfectly for my use-case.

## Setting Expectations
**What it won't do**
- This script will not change the background of the drive encryption screen, which is not something I wish to happen.

**What it will do**
- The script allows you to tailor the default GDM login screen according to your preferences. When setting a background image, I advise using an absolute path to a locally stored image to avoid any issues. Relative paths or remote images may not work and could possibly break the login screen.

To execute the script, first make it executable:
```bash
chmod 700 popgmdchanger.sh
```
## Executing the Script with sudo privileges:
```bash
sudo ./popgmdchanger.sh --image /PATH/TO/YOUR/IMAGE
```
Replace --image /PATH/TO/YOUR/IMAGE with the path to your selected image.

## Using a Blurred Image as GDM Background

If you're interested in using a blurred image for your GDM background, a practical method involves choosing an image and applying blur through the Lunapic website. The procedure is as follows:

1. Visit the online image editor on the [Lunapic website](https://www12.lunapic.com/editor/?action=blur).
2. Upload your chosen image.
3. Apply the blur effect as per your liking.
4. Save the blurred image onto your local machine.

Once your blurred image is prepared, you can set it as your GDM background by using the script as mentioned earlier:

```bash
sudo ./popgmdchanger.sh --image /PATH/TO/YOUR/BLURRED/IMAGE
```
Please remember to replace `/PATH/TO/YOUR/BLURRED/IMAGE` with the actual path of your blurred image.

