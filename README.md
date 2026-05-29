# Licensing

Dungeon assets were obtained from Quaternius under the Creative Commons License: https://creativecommons.org/publicdomain/zero/1.0/

Player model asset was obtained from SRCoder via the MIT License: https://mit-license.org/

# Cameras

This project includes custom camera implementations as follows:

- Rotational Fixed
- Dynamic Fixed
- Fixed
- Third-person Orbital (custom)

Third-person Orbital is enabled by default, but you can override it by selecting any other camera in a scene's node hierarchy and toggling the "Current" property in the inspector dock, with the exception of the Dynamic Fixed Camera.

To get the dynamic fixed camera to work, first re-attach the existing dynamic trigger gd script file to the dynamic trigger Area3d node, then run the scene. After the player enters the trigger area, the camera will switch views automatically.

The third-person orbital camera is listed as "custom" to differentiate it from the third-person camera that came originally with SRCoder's player model. It contains original code with additional collision detection and interpolation.

# Scenes

This is the list of constructed scenes for camera testing in this project. More may be added in the future

- hallway
- library
- raised platform
- empty room

# Future updates

An implementation of more novel camera ideas and scenes is planned in future releases