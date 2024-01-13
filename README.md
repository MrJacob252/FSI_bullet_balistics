# FSI_bullet_balistics
Project for Dynamic Simulations class to simulate bullet trajectory


# Controls
- ### Aiming and Shooting 
  - Mouse movement to aim
  - **LMB**: Fire projectile
  - **RMB**: Switch to camera above "gun"
  - **E**: Swith if camera should follow bullet or not
- ### Settings
  - **ESC**: Return to settings screen
  - **Arrow Left**: Increase wind speed by 1 ms<sup>-1</sup>
  - **Arrow Right**: Decrease wind speed by 1 ms<sup>-1</sup>
  - **Arrow Up**: Decrease gravity by 1 ms<sup>-2</sup>
  - **Arrow Down**: Increase gravity by 1 ms<sup>-2</sup> 
  - **G**: Reset gravity back to 9.8 ms<sup>-2</sup>
  - **Page Up**: Increase muzzle velocity by 1 ms<sup>-1</sup>
  - **Page Down**: Decrease muzzle velocity by 1 ms<sup>-1</sup>
  - **Home**: Increase engine time scale by 10% (max 100%)
  - **End**: Decrease engine time scale by 10% (min 10%)
- ### Modifier Keys
  - **Ctrl**: Change with settings keys is now multiplied by 10 (not engine scale)

# Sources
- [Official Godot documentation](https://docs.godotengine.org/en/stable/)
- Basics of how to create FPS controller in godot from:
  - [Lukky](https://www.youtube.com/watch?v=xIKErMgJ1Yk)
  - [Garbaj](https://www.youtube.com/watch?v=IDsoEAj5xG0)
- Bullet physics that worked as I wanted were implemented with use of tutorial from [Kids Can Code](https://kidscancode.org/godot_recipes/3.x/3d/3d_shooting/index.html)
- Textures for floor and targets are from [Kenney](https://kidscancode.org/godot_recipes/3.x/3d/3d_shooting/index.html)
- HDRI skybox is from [Polyhaven](https://polyhaven.com/hdris)
- ChatGPT 3.5 was also used in creation of this project but because it does not have knowledge of Godot 4.0 and up it's usefulness could be a bit questionable