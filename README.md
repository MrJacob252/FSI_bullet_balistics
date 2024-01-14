# FSI_bullet_balistics

Project for Dynamic Simulations class to simulate bullet trajectory

# Acknowledgement of weak sides

Because this was my firs time working with Godot or any sort of game engine I got stuck quite often and it took me quite a while to figure how to do the a projectile motion that wasn't completely broken and worked all the time not only in some edge cases.

This means the calculation of the bullet motion was quite simplified in the end. Wind was consideted only as pushing in X axis of the global coordinate system.

Force of the wind was calculated as a preassure created by the wind onto a flat crossection multiplied by [drag coefficient](https://en.wikipedia.org/wiki/Drag_coefficient) of a sphere.

$$F = A \times P \times C_d$$

$$P = 0.5 \times \rho \times v^2$$

The final velocity applied onto the the bullet was calculated from this force *F*.

$$a = F / m$$

$$m = V \times \rho$$

$$v = a \times m$$

Where bullets' density was considered as being 11340 kg/m<sup>3</sup> which is a density of Lead.

This could 100% be imporoved but it workes as a proof of concept. If the wind speed is set to 20 000 m/s (which is 58 times the speed of sound) the bullet visibly turn. Which is nice.

# Running the project

Because of the requirements to not submit any binaries I did not include any here. To run the final project do this:

- Download [Godot](https://godotengine.org/) from official website (version 4.2 or higher)
- Load project.godot in the project folder
- In a right hand corner press the "Play project" button or F5
  - Project should be settup to run from main menu scene but if that's not the case press Ctrl + Shift + F5 and select main_menu.tscn
  - To stop running the project when mouse is captured use F8 (or Alt + Tab and press the stop button in Editor)

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