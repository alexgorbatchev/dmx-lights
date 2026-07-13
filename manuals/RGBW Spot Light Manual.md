# RGBW Spot Light

## User Manual

**Please read the instruction carefully before use!**

---

### 1. Lens and Focus Adjustment
After installation, rotate the lens left and right to change the focal length to find the best focusing position and make the effect clearer. You can fine-tune the focal length as you change the irradiation distance.

**Attention:** The voice control mode is for each lamp to receive sound independently, and the same light color cannot be synchronized with the master-slave mode and the DMX mode when all lights are on.

---

### 2. Control Panel Buttons and Display
The device features a digital display with four buttons under/above the digits:

```
  8.8.8.8.
MENU UP DOWN ENTER
```

* **[MENU]** Menu selection button.
* **[DOWN]** Scrolls through menu items and numbers in descending order.
* **[UP]** Scrolls through menu items and numbers in ascending order.
* **[ENTER]** Used to select and confirm/store the current selection.

---

### 3. DMX512 Connection
When you use DMX512 stage lighting controller with this product, take the common 192 DMX512 controller for example:

1. First use DMX512 signal line to properly connect the controller with the product, the product with the product, and then connect the power supply.
2. If the console is only connected to this lamp and controlled at the same time, it will be set to the same address `A001` and press `ENTER`, and then operate according to the controller's usage method.
3. If the controller controls several different lamps or controls them separately, it shall set different address code `a001` - `a512` according to the actual situation, press `ENTER`, and then operate according to the controller's usage method.

*Different controller, the operation method is not the same, the specific controller operation method please refer to the controller manual, video tutorial, engineers to learn.*

#### Daisy Chain Connection Diagram:
```
[ DMX512 Controller ]
         |
         | (DMX512 Signal Line)
         v
  [ THE FIRST LIGHT ] ---> [ SECOND LIGHT ] ---> [ THIRD LIGHT ] ---> [ FOUR LIGHT ]
```

---

### 4. Display Digital Control

| Press Menu | Press up or down to change the value and press ENTER to confirm | description |
| :--- | :--- | :--- |
| **A_** | 001~512 | DMX (6CH) / slave serial |
| **Run_** | 0 | close |
| | 1 | red, green, blue, white jump change |
| | 2 | Red static, green, blue, white jump change |
| | 3 | green static, red, blue, white jump change |
| | 4 | blue static, red, green, white jump change |
| | 5 | white static, red, green, blue jump change |
| | 6 | red, green, blue, white gradual change, speed slow |
| | 7 | red, green, blue, white gradual change, speed fast |
| | 8 | red, green, gradual change, speed fast |
| | 9 | red, blue, gradual change, green white close |
| | A | Green blue gradual change, red white close |
| | b | red, green, blue gradual change |
| | C | red, green, blue white jump change |
| **Sou_1** | *None* | Sound 1 Change color and strobe |
| **Sou_2** | *None* | Sound 2 Change colors with sound |
| **Sou_3** | *None* | Sound3 Change colors and flicker with sound |
| **Colr**<br>*(press Enter)* | r000~255 | Red light from dark to bright |
| | g000~255 | Green light from dark to bright |
| | b000~255 | Blue light from dark to bright |
| | y000~255 | white light from dark to bright |
| **Leon** | *None* | Keep the display light |
| **LOFF**<br>*(Press up and down to switch)* | *None* | The display will be off after 3S and the keys will light up again |

---

### 5. DMX512 Channel Control

This fixture operates under a standard **6-channel (6CH)** DMX profile.

**CRITICAL GOTCHA:** To manually mix colors using Channels 2, 3, 4, and 5, you MUST set Channel 1 between 240-255. If Channel 1 is between 9-134, it will override manual control and force all colors on simultaneously as a global dimmer.

| channel | channel value | Function |
| :---: | :---: | :--- |
| **CH1** | 0~8 | No effect |
| | 9~134 | Red green blue white light from dark to bright |
| | 135~239 | strobe, speed from slow to fast |
| | 240~255 | Ch2-ch5 effect |
| **CH2** | 0 | Red light keeps dark |
| | 1~255 | Red light from dark to bright |
| **CH3** | 0 | green light keeps dark |
| | 1~255 | green light from dark to bright |
| **CH4** | 0 | blue light keeps dark |
| | 1~255 | blue light from dark to bright |
| **CH5** | 0 | white light keeps dark |
| | 1~255 | white light from dark to bright |
| **CH6** | 0~2 | No effect |
| | 3~31 | red, green, blue, white jump change |
| | 32~63 | red static, green, blue, white jump change |
| | 64~79 | green static, red, blue, white jump change |
| | 80~95 | blue static, red, green, white jump change |
| | 96~111 | white static, red, green, blue jump change |
| | 112~143 | red, green, blue, white gradual change, speed slow |
| | 144~159 | red, green, gradual change, speed fast |
| | 160~175 | red, blue, gradual change, green white close |
| | 176~191 | Green blue gradual change, red white close |
| | 192~207 | red, green, blue gradual change |
| | 208~223 | red, green, blue white jump change |
| | 224~239 | Sound 1 Change color and strobe |
| | 240~249 | Sound 2 Change colors with sound |
| | 250~255 | Sound 3 Change colors and flicker with sound |
