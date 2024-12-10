# 🎮 Ping Pong Game Project

## Course: EE2014 – Computer Organization and Assembly Language (FALL 2024)  
### Instructor: Dr. M. Usama, Ali Hamza, M. Adeel  
### University: National University of Computer and Emerging Sciences, Chiniot-Faisalabad Campus  

---

### 🧑‍🤝‍🧑 Project Members:
- **Areeba Anwar** 👩‍💻
- **Fatima** 👩‍💻

---

### 🏓 Project Overview:
The Ping Pong game is developed entirely in **NASM** assembly language, compatible with Intel 8086 architecture in a **DOSBox** environment. The game includes:
- **Player-Controlled Paddles** 🏓
- **Ball Movement** ⚽
- **Score Counting** 📊
- **Game-Winning Conditions** 🏆  
The game also features **background patterns** to enhance the visual appeal.

---

### ⚙️ Core Features Implemented:

1. **Player-Controlled Paddles**:  
   - **Right Paddle (Player 1)** is controlled by the 'W' and 'S' keys ⬆️⬇️.  
   - **Left Paddle (Player 2)** is controlled by the Up and Down Arrow keys ⬆️⬇️.

2. **Ball Movement**:  
   - The ball moves diagonally and reflects off the **walls** and **paddles** based on game logic.

3. **Reflection Logic**:  
   - The ball reflects off the **top** and **bottom** walls 🏰, as well as the **paddles** 🏓, with direction logic ensuring proper bounce behavior.

4. **Score Counting**:  
   - Tracks player scores and updates them when the ball crosses either boundary 🚶‍♂️.

5. **Winning Condition**:  
   - The game ends when a player reaches a pre-set score (e.g., **5 points**) 🏆, with a message displaying the winner.

6. **Pause/Unpause**:  
   - Press **P** to pause and unpause the game ⏸️.

7. **Background Graphics**:  
   - Moving patterns are added to the background 🎨 to enhance the visual experience. Players can toggle the patterns on or off before starting the game.

---

### 🌟 Additional Features:
- Add **dynamic sound effects** 🔊 for an immersive experience.
- Implement **improved collision mechanics** for better ball interaction.
- Create **advanced background effects** 🎭 for more engaging gameplay.

---

### 🎮 Game Flow:
1. **Start**: Choose the winning score and decide on background patterns.  
2. **Gameplay**: Players use **W/S** and **Arrow Keys** to control paddles. Ball moves and bounces based on collisions.  
3. **Game End**: The game ends when one player wins, displaying a message like **"Player 1 Wins!"** 🏆.

---

### 🛠️ Technical Details:
- **Key Press Detection**: Used **INT 16h** to capture key presses for paddle movement.
- **Memory Management**: Efficient video memory handling to ensure smooth graphics rendering.
- **Collision Handling**: Ball reflection logic after hitting the walls and paddles.
- **Game State Management**: Continuously updated the game state (paddles, ball, scores) in each game loop.

---

### 🧩 Challenges and Solutions:

- **Challenge**: Ensuring smooth gameplay with **moving background patterns** without affecting performance.
  - **Solution**: Used simple, small patterns that were easy to draw and erase to keep the game running smoothly.

- **Challenge**: Managing **real-time user input** for paddle control while maintaining gameplay responsiveness.
  - **Solution**: Utilized efficient key press detection to ensure that player movements were detected instantly.

---

### 📹 Video Submission:
A **1-2 minute gameplay video** will showcase:
- Paddle movement
- Ball reflection
- Score counting
- Game-winning condition and any extra features added.

---

### 🎉 Conclusion:
This Ping Pong game project showcases an understanding of assembly language programming while implementing core game mechanics. It highlights the power of low-level control for handling input, graphics, and game logic efficiently.

---

### 📜 Documentation:
In addition to the code, this project includes detailed documentation covering:
- Introduction: Overview of the game.
- Implementation: Detailed technical aspects and logic flow.
- Additional Features: Extra functionalities added.
- Challenges: Issues faced and how they were overcome.

---

### 🎮 Watch GamePlay Now!
[Click here to watch the gameplay video and see the game in action!](https://go.screenpal.com/watch/cZl6YdnnwPe)
