org 0x0100
jmp main

; EPIC WELCOME SCREEN YEAHHH

welcome1: db 'Welcome to EPIC ping pong, where EPICNESS knows no bounds ', 0
rule1: db '1. Player one controls paddle with W and S', 0
rule2: db '2. Player two controls paddle with up and down key', 0
sarcasm: db 'But that much was EPICLY obvious', 0
credits: db ' Made by Areeba Epic and Fatima Epic btw. *Wink Wink* ', 0
entry: db 'Press enter to continue', 0


; PLAYER DATA

p1: db 'Player 1: ', 0
p2: db 'Player 2: ', 0
p1_score: db 0
p2_score: db 0

; Cat face easter egg (will be shown on keypress)
cat1: db ' /\_/\  ', 0
cat2: db '( o.o ) ', 0
cat3:  db ' > ^ <   ', 0
wisdom: db 'Some words of wisdom from the wise elder feline: ', 0
msg1: db 'Grace against time, watching how fleeting moments pass.', 0
msg2: db 'Remembering the moments when the sky lit up with color.', 0
msg3: db 'Every light flickers briefly, but leaves an imprint that lasts.', 0
msg4: db 'Grace through the years, knowing some things will never fade.', 0

ball_char: db 'O'              ; ball character 'O'
empty_char: db ' '             ; empty character for clearing
row: dw 14                     ; starting row (center of the screen)
col: dw 40                     ; starting column (center of the screen)
row_delta: dw 1                ; row direction (1 = down, -1 = up)
col_delta: dw 1                ; column direction (1 = right, -1 = left)
screen_width equ 80            ; screen width
screen_height equ 25           ; screen height
bottom_wall equ 22             ; y position of the bottom wall (row 23)
top_wall equ 1                 ; y position of the top wall (row 1)
second_row equ 2               ; y position of the second row (row 2)
right_wall equ 77              ; column position of the right wall (col 77)
left_wall equ 2                ; column position of the left wall (col 1)
ball_direction dw 0            ; changes based on reset (0 = right cycle, 1 = left cycle)


paddle_start_row db 12       ; Initial left paddle row (middle of the screen)
paddle_col db 10             ; Column for the left paddle
right_paddle_start_row db 12 ; Initial right paddle row
right_paddle_col db 70       ; Column for the right paddle
paddle_height db 3

; GAME OVER
over: db 'GAME OVER', 0
p1_win: db 'Player one won EPICLY', 0
p2_win: db 'Player two won EPICLY', 0

fill_pattern_running db 1 ; Initially, set the flag to true (running)

main:
    ; Set video mode (text mode 80x25)
    mov ah, 00h
    mov al, 03h
    int 10h

    ; Set the initial direction (down-right diagonal for ball direction 0)
    mov word [row_delta], 1
    mov word [col_delta], 1


  
    call epic_clrscr
    call epic_welcome_screen
    call take_Arfa_bhai_to_epic_screen    
    call epic_clrscr         
    call draw_boundary
    call epicly_drawing_boundary
    call display_player_data

    cmp byte [fill_pattern_running], 1
    jne main_loop   ; Skip if the pattern is not running

    ; If the pattern is running, call the fill_pattern in the background
    call fill_pattern


main_loop:
start_loop:
    ; Ball movement logic (continuous)

    call draw_ball              ; Draw the ball at its new position
    call delay             ; Add delay for smooth motion
    call delay             ; Add delay for smooth motion
    call fill_pattern
    call draw_paddle            ; Draw the paddle in its current position
    call draw_right_paddle      ; Draw the right paddle
    call clear_ball             ; Clear the previous ball position
    call update_position        ; Update ball position continuously
    call reflection
    call display_player_data
    call check_epic_winner

    call take_input

    jmp start_loop

short_jump_move_up:
 jmp move_up

short_jump_move_down:
 jmp move_down

short_jump_move_right_up:
 jmp move_right_up

short_jump_move_right_down:
 jmp move_right_down
 
short_jump_reverse_direction:
 jmp reverse_direction

short_jump_reset_center:
 jmp reset_center

short_pause_game:
 jmp pause_game
 
short_jump_Reflect_bottom_right_paddle:
 jmp Reflect_bottom_right_paddle
 
short_jump_Reflect_up_right_paddle:
 jmp Reflect_up_right_paddle

short_wait_for_enter:
 jmp wait_for_enter


stop_fill_pattern:
    cmp byte [fill_pattern_running], 0 ; Set flag to stop the pattern
    ret

take_input:
    ; Check if a key is pressed (non-blocking)
    mov ah, 0x01              ; BIOS: Check if a key is pressed
    int 0x16                  ; Call BIOS
    jz no_key_pressed         ; Jump if no key is pressed (zero flag set)

    ; A key is pressed, so process it
    mov ah, 0x00              ; BIOS: Get key press
    int 0x16                  ; Call BIOS
    mov al, ah                ; Get the scan code
         


    cmp al, 0x19               ; Check if 'P' key is pressed
    je short_pause_game             ; Call pause subroutine if 'P' is pressed

    ; Check key and act accordingly for paddle movement
    cmp al, 0x11              ; 'W' key (scan code)
    je short_jump_move_up
    cmp al, 0x1F              ; 'S' key (scan code)
    jz short_jump_move_down
    cmp al, 0x48              ; Up arrow (scan code)
    jz short_jump_move_right_up
    cmp al, 0x50              ; Down arrow (scan code)
    jz short_jump_move_right_down

no_key_pressed:
    ret


fill_pattern:
 pusha
    mov ax, 0xb800         ; Set segment to video memory
    mov es, ax
    xor di, di             ; Start at the beginning of the screen
 
    add di, 320

    mov ax, 0x025F         ; Set the pattern character to '_'
    or  ax, 0x8000         ; Set the blink attribute (bit 7 = 1)
    mov bx, 0              ; Line counter

 l1:
    mov cx, 80
 draw_pattren_line:
    mov word [es:di], ax    ; Write pattern to screen
    add di, 2               ; Move to the next character
    loop draw_pattren_line

    add di, 160
    inc ah
    cmp ah, 0x05
    jne continue2
    mov ah, 0

 continue2:
    ; Check if the pattern reached the right edge of the screen
    add bx, 1               ; Increment line counter
    cmp bx, 11              ; Check if we've reached the 25th line
    jl l1                   ; If not, continue drawing

 popa
 ret



take_Arfa_bhai_to_epic_screen:
    mov ah, 0x01          ; DOS function to read a character
    int 0x21              ; Wait for user input
    cmp al, 0x41          ; Check if Enter key was pressed
    jne short_wait_for_enter     ; If not Enter, keep waiting

    ; 'A' key was pressed, call the cat face subroutine
    call epic_clrscr
    call show_cat_face        ; Show cat face if 'A' is pressed

    jmp short_wait_for_enter
done:
    ret



sound_delay:
 pusha

 mov cx, 0xFF
 sound_loop:
 loop sound_loop

 popa
 ret

pattren_delay:
 pusha
    mov cx, 0x8000
 pattren_delay_loop:
    loop pattren_delay_loop
 popa
 ret

 reflection:
  
     call check_paddle
    
  ; Check if the ball hits the bottom wall
    cmp word [row], bottom_wall
    jge short_jump_reverse_direction      ; If row >= 23, reverse direction

    ; Check if the ball hits the top wall
    cmp word [row], top_wall
    jle short_jump_reverse_direction      ; If row <= 1, reverse direction

    ; Check if the ball hits the second row (row 2)
    cmp word [row], second_row
    jle short_jump_reverse_direction      ; If row <= 2, reverse direction

    ; Check if the ball hits the left wall (col = 1)
    cmp word [col], left_wall
    jle short_jump_reverse_direction      ; If column <= 1, reverse direction

    ; Check if the ball hits the right wall (col = 77)
    cmp word [col], right_wall
    je short_jump_reset_center            ; If column = 77, reset to center

    ; Check if the ball hits the left wall (col = 2)
    cmp word [col], 3
    je short_jump_reset_center            ; If column = 2, reset to center
   ret


check_paddle:
   
    cmp word [col], 2
    je short_jump_reset_center            ; If column = 2, reset to center

    ; Check if the ball hits the left paddle (column 10)
    mov al, [row]                    ; Get the ball's current row
    mov bl, [col]                    ; Get the ball's current column
    mov dl, [paddle_col]             ; Get the column of the left paddle
    mov dh, [paddle_start_row]       ; Get the row of the left paddle

    ; Check if the ball is 1 column before the second column of the paddle (col 11)
 
     
    ;add dl, 1
    cmp bl, dl                    ; If the ball is about to hit the second column of the paddle
    je reflect_before_hit_left ; If the ball is 1 column before the second column of the paddle, reflect early


    jne check_hit_paddle_right        ; If they don't match, check the right paddle

reflect_before_hit_left:

 check_all_chars_in_paddle_left:
    mov si, 4               ; Number of rows (height of paddle)

check_all_chars_in_paddle_left_loop:
    cmp al, dh 
    je do_reflection_through_left_paddle

    inc dh                  
    dec si
    cmp si, 0
    jne check_all_chars_in_paddle_left_loop

  jmp no_collision

check_hit_paddle_right:
    ; Check if the ball hits the right paddle (column 70)
    mov al, [row]                    ; Get the ball's current row
    mov bl, [col]                    ; Get the ball's current column
    mov dl, [right_paddle_col]       ; Get the column of the right paddle
    mov dh, [right_paddle_start_row] ; Get the row of the right paddle


    ; Check if the ball is 1 column before the right paddle (col 69)

    ;sub dl, 1
    cmp bl, dl                        ; Compare the ball's column with the paddle's column

    je reflect_before_hit_right       ; If the ball is 1 column before, reflect early
    jne no_collision                  ; If they don't match, no collision


reflect_before_hit_right:
    
check_all_chars_in_paddle_right:
    mov si, 4               ; Number of rows (height of paddle)

check_all_chars_in_paddle_right_loop:
    cmp al, dh 
    je do_reflection_through_right_paddle


    inc dh                  
    dec si
    cmp si, 0
    jne check_all_chars_in_paddle_right_loop

no_collision:
    ret

  run:
   ;jmp do_reflection_through_left_paddle

do_reflection_through_right_paddle:
   cmp word[row_delta], -1 
   je short_jump_Reflect_up_right_paddle       ; If ball is in the lower half, reflect upward

   cmp word[row_delta], 1 
   je short_jump_Reflect_bottom_right_paddle    ; If ball is in the upper half, reflect downward

do_reflection_through_left_paddle:
   cmp word[row_delta], -1 
   je Reflect_up_left_paddle       ; If ball is in the lower half, reflect upward

   cmp word[row_delta], 1
   je Reflect_bottom_left_paddle    ; If ball is in the upper half, reflect downward
  

Reflect_up_left_paddle:
   call draw_paddle
    ; Reflect ball upward from the left paddle
    mov word [row_delta], -1          ; Set row delta to move upwards
    mov word [col_delta], 1           ; Set column delta to move right
    mov word[ball_direction], 0
 
    jmp start_loop

Reflect_bottom_left_paddle:
   call draw_paddle
    ; Reflect ball downward from the left paddle
    mov word [row_delta], 1           ; Set row delta to move downward
    mov word [col_delta], 1           ; Set column delta to move right
    mov word[ball_direction], 0
 
    jmp start_loop

Reflect_up_right_paddle:
 call draw_right_paddle
    ; Reflect ball upward from the right paddle
    mov word [row_delta], -1          ; Set row delta to move upwards
    mov word [col_delta], -1          ; Set column delta to move left
    mov word[ball_direction], 1
    
    jmp start_loop

Reflect_bottom_right_paddle:
 call draw_right_paddle
    ; Reflect ball downward from the right paddle
    mov word [row_delta], 1           ; Set row delta to move downward
    mov word [col_delta], -1          ; Set column delta to move left
    mov word[ball_direction], 1
    jmp start_loop

reset_center:
    ; Reset ball to center of the screen
    mov word [row], 14        ; reset to center row
    mov word [col], 40        ; reset to center column
    ; Set the new direction to down-left (left cycle)
    mov word [row_delta], 1   ; set row direction down
    mov word [col_delta], -1  ; set column direction left
    cmp word [ball_direction], 1
    je change_direction
    mov word [ball_direction], 1  ; Change to left cycle
    add word [p1_score], 1
    mov word [row_delta], 1   ; set row direction down
    mov word [col_delta], -1  ; set column direction left
    jmp start_loop

change_direction:
    mov word [ball_direction], 0  ; Change to right cycle
    add word [p2_score], 1
    mov word [row_delta], 1   ; set row direction down
    mov word [col_delta], 1  ; set column direction left
    jmp start_loop

reverse_direction:
    ; Handle ball reversal when hitting walls
    cmp word [ball_direction], 0
    jne reverse_left_cycle     ; If ball direction = 0 (right cycle)

reverse_right_cycle:
    ; Ball direction = 0 (right cycle): Move bottom-right to top-right
    cmp word [row], bottom_wall
    jge set_upward_right       ; If row >= 23, move diagonally up-right
    cmp word [row], second_row
    jle set_bottom_right       ; If row <= 2, move diagonally bottom-right
    neg word [row_delta]       ; Reverse the row direction (upward)
    neg word [col_delta]       ; Reverse the column direction (left)
    jmp start_loop

reverse_left_cycle:
    ; Ball direction = 1 (left cycle): Move bottom-left to top-left
    cmp word [row], bottom_wall
    jge set_upward_left        ; If row >= 23, move diagonally up-left
    cmp word [row], second_row
    jle set_bottom_left        ; If row <= 2, move diagonally bottom-left
    neg word [row_delta]       ; Reverse the row direction (upward)
    neg word [col_delta]       ; Reverse the column direction (right)
    jmp start_loop

set_upward_right:
    ; Reset row direction to upward-right (ball direction = 0)
    mov word [row_delta], -1
    mov word [col_delta], 1
    jmp start_loop

set_upward_left:
    ; Reset row direction to upward-left (ball direction = 1)
    mov word [row_delta], -1
    mov word [col_delta], -1
    jmp start_loop

set_bottom_right:
    ; Reflect ball from second row downward diagonally (right cycle)
    mov word [row_delta], 1   ; set row direction down
    mov word [col_delta], 1   ; set column direction right
    jmp start_loop

set_bottom_left:
    ; Reflect ball from second row downward diagonally (left cycle)
    mov word [row_delta], 1   ; set row direction down
    mov word [col_delta], -1  ; set column direction left
    jmp start_loop



draw_ball:
    mov ah, 02h                  ; Set cursor position
    mov dh, [row]                ; dh = row
    mov dl, [col]                ; dl = column
    mov bh, 0                    ; Page number
    int 10h

    mov ah, 09h                  ; Write character at cursor position
    mov al, [ball_char]          ; Character: ball ('O')
    mov bl, 0fh                  ; Attribute: white text
    mov cx, 1                    ; Number of times to write
    int 10h
    ret

clear_ball:
    mov ah, 02h                  ; Set cursor position
    mov dh, [row]                ; dh = row
    mov dl, [col]                ; dl = column
    mov bh, 0                    ; Page number
    int 10h

    mov ah, 09h                  ; Write empty character (space) at cursor position
    mov al, [empty_char]         ; Empty character (' ')
    mov bl, 0fh                  ; Attribute: white text
    mov cx, 1                    ; Number of times to write
    int 10h
    ret

update_position:
    xor ax, ax
    ; Update ball's position
    mov ax, word [row_delta]
    add word [row], ax           ; Update row
    mov ax, word [col_delta]
    add word [col], ax           ; Update column
    ret

delay:                    ; Simplified delay function
    mov cx, 0xFFFF              ; Delay for a long enough period
delay_loop:
    loop delay_loop        ; This loop will slow down the ball's movement
    ret

move_up:
    ; Erase left paddle before moving
    call erase_paddle

    ; Check if the first character of paddle is at the top (row 3)
    mov al, [paddle_start_row]
    cmp al, 0x03            ; Row 3 is the top wall
    jle no_move_up

    ; Move paddle up
    dec byte [paddle_start_row]

no_move_up:
    ; Redraw left paddle
    call draw_paddle
    jmp main_loop

move_down:
    ; Erase left paddle before moving
    call erase_paddle

    ; Check if the last character of paddle is at the bottom (row 23)
    mov al, [paddle_start_row]
    add al, 4              ; Add 2 to get the last row of the paddle (3rd character)
    cmp al, 0x17            ; Row 23 is the bottom wall
    jge no_move_down

    ; Move paddle down
    inc byte [paddle_start_row]

no_move_down:
    ; Redraw left paddle
    call draw_paddle
    jmp main_loop

move_right_up:
    ; Erase right paddle before moving
    call erase_right_paddle

    ; Check if the first character of the right paddle is at the top (row 3)
    mov al, [right_paddle_start_row]
    cmp al, 0x03            ; Row 3 is the top wall
    jle no_move_right_up

    ; Move right paddle up
    dec byte [right_paddle_start_row]

no_move_right_up:
    ; Redraw right paddle
    call draw_right_paddle
    jmp main_loop

move_right_down:
    ; Erase right paddle before moving
    call erase_right_paddle

    ; Check if the last character of the right paddle is at the bottom (row 23)
    mov al, [right_paddle_start_row]
    add al, 4              ; Add 2 to get the last row of the right paddle (3rd character)
    cmp al, 0x17            ; Row 23 is the bottom wall
    jge no_move_right_down

    ; Move right paddle down
    inc byte [right_paddle_start_row]

no_move_right_down:
    ; Redraw right paddle
    call draw_right_paddle
    jmp main_loop

draw_paddle:
    ; Draw a vertical paddle (1 column wide, 3 pixels tall)
    mov cx, 1
    mov si, 4               ; Number of rows (height of paddle)
    mov al, 0xDB            ; ASCII character for a filled block (paddle block)
    mov bl, 0x09            ; White color

    mov dl, [paddle_col]    ; Fixed paddle column (horizontal position)
    mov dh, [paddle_start_row] ; Starting row (vertical position)

draw_loop:
    call set_cursor         ; Move cursor to (dl, dh)
    mov ah, 0x09            ; Write character function
    int 0x10
    inc dh                  ; Move down one row (next vertical position)
    dec si
    cmp si, 0
    jne draw_loop
    ret

draw_right_paddle:
    ; Draw a vertical paddle for the right side (1 column wide, 3 pixels tall)
    mov cx, 1
    mov si, 4               ; Number of rows (height of paddle)
    mov al, 0xDB            ; ASCII character for a filled block (paddle block)
    mov bl, 0x02            ; White color

    mov dl, [right_paddle_col] ; Fixed paddle column (horizontal position)
    mov dh, [right_paddle_start_row] ; Starting row (vertical position)

draw_right_loop:
    call set_cursor         ; Move cursor to (dl, dh)
    mov ah, 0x09            ; Write character function
    int 0x10
    inc dh                  ; Move down one row (next vertical position)
    dec si
    cmp si, 0
    jne draw_right_loop
    ret

set_cursor:
    ; Set cursor position using dl (column) and dh (row)
    mov ah, 0x02            ; Set cursor position function
    int 0x10
    ret

erase_paddle:
    ; Erase 3 vertical blocks (characters) representing the left paddle
    mov cx, 2               ; Number of rows (height of paddle)
    mov si, 4
    mov al, ' '             ; ASCII character for space
    mov bl, 0x07            ; White background color

    mov dl, [paddle_col]    ; Fixed paddle column (horizontal position)
    mov dh, [paddle_start_row] ; Starting row (vertical position)

erase_left_loop:
    call set_cursor         ; Move cursor to (dl, dh)
    mov ah, 0x09            ; Write character function
    int 0x10
    inc dh                  ; Move down one row (next vertical position)
    dec si
    cmp si, 0
    jne erase_left_loop
    ;loop erase_left_loop    ; Repeat for 3 rows
    ret

erase_right_paddle:
    ; Erase 3 vertical blocks (characters) representing the right paddle
    mov cx, 2               ; Number of rows (height of paddle)
    mov si, 4
    mov al, ' '             ; ASCII character for space
    mov bl, 0x07            ; White background color

    mov dl, [right_paddle_col] ; Fixed paddle column (horizontal position)
    mov dh, [right_paddle_start_row] ; Starting row (vertical position)

erase_right_loop:
    call set_cursor         ; Move cursor to (dl, dh)
    mov ah, 0x09            ; Write character function
    int 0x10
    inc dh                  ; Move down one row (next vertical position)
    dec si
    jne erase_right_loop
    ;loop erase_right_loop   ; Repeat for 3 rows
    ret

shorter_delay:
 pusha
 mov cx, 0XF000

  delay_loop2:
  loop delay_loop2

 popa
 ret
;------------;

epic_clrscr:            ; clears the screen like a good boi
    pusha

    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, 0x0720
    mov cx, 2000

    cld
    rep stosw

    popa
    ret

;------------;

epic_welcome_screen:
  
  pusha
 mov ax, 0xb800
 mov es, ax
 mov si, welcome1
 mov ax, 0 
 mov di, 324
 
 mov ah, 0x07
 
 welcome_l1:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne welcome_l1
  

 mov di, 484
 mov cx, 60
 mov al, 0x2D
 mov ah, 0x0B

 draw_line:
 mov word[es:di], ax
 call shorter_delay
 add di, 2
 loop draw_line

 mov ah, 0x07
 mov di, 644
 mov si, rule1

 welcome_l2:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne welcome_l2

 mov di, 964
 mov si, rule2
 
 welcome_l3:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne welcome_l3

 mov di , 1284
 mov si, sarcasm
 mov ah, 0x04

 welcome_l4:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne welcome_l4

 mov di ,0
 mov di , 1604
 mov si, credits
 mov ah, 0x07
 
 welcome_l5:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne welcome_l5

 ; Prompt user to press Enter
 mov di, 1926
 mov si, entry

 welcome_l6:

 mov al, [si]
 mov word[es:di], ax
 add di, 2
 inc si
 cmp byte [si], 0
 jne welcome_l6


 popa
 ret


;------------;
wait_for_enter:
  mov ah, 0x01          ; DOS function to read a character
  int 0x21              ; Wait for user input
  cmp al, 0x0D          ; Check if Enter key was pressed
  jne wait_for_enter     ; If not Enter, keep waiting
  ret

;------------;

show_cat_face:
    pusha
    mov ax, 0xb800
    mov es, ax

    mov di, 1000   ; Starting position to display cat face
    mov ax, 0
    mov ah, 0x0D
    mov si, cat1

    cat_l1:
    mov al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    cmp byte [si], 0
    jne cat_l1
    
    add di, 144
    mov si, cat2
    call delay
    call delay

    cat_l2:
    mov al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    cmp byte [si], 0
    jne cat_l2

    mov si, cat3
    add di, 144
    call delay
    call delay

    cat_l3:
    mov al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    cmp byte [si], 0
    jne cat_l3

    call word_of_wisdom

    popa
    ret

;------------;
 
 word_of_wisdom:

 pusha
  
  add di, 2
  mov ah, 0x03
  mov si, wisdom

  wisdom_l1:
  mov al, [si]
  mov word[es:di], ax
  call delay
  add di, 2
  inc si
  cmp byte [si], 0
  jne wisdom_l1

   ;----------displaying the 1st msg----------;
  mov di, 2722

  mov si, msg1
  mov ah, 0x09
  mov al, [si]
  mov word[es:di], ax
  inc si
  add di, 2
  call delay
  mov ah, 0x03

  wisdom_l2:
  mov al, [si]
  mov word[es:di], ax
  call delay
  add di, 2
  inc si
  cmp byte [si], 0
  jne wisdom_l2

 ;----------displaying the 2nd msg----------;
  mov di, 2882

  mov si, msg2
  mov ah, 0x09
  mov al, [si]
  mov word[es:di], ax
  inc si
  add di, 2
  call delay
  mov ah, 0x03

  wisdom_l3:
  mov al, [si]
  mov word[es:di], ax
  call delay
  add di, 2
  inc si
  cmp byte [si], 0
  jne wisdom_l3

 ;----------displaying the 3rd msg----------;
 mov di, 3042

  mov si, msg3
  mov ah, 0x09
  mov al, [si]
  mov word[es:di], ax
  inc si
  add di, 2
  call delay
  mov ah, 0x03

  wisdom_l4:
  mov al, [si]
  mov word[es:di], ax
  call delay
  add di, 2
  inc si
  cmp byte [si], 0
  jne wisdom_l4
 
 ;----------displaying the 4th msg----------;

  mov di, 3202

  mov si, msg4
  mov ah, 0x09
  mov al, [si]
  mov word[es:di], ax
  inc si
  add di, 2
  call delay
  mov ah, 0x03

  wisdom_l5:
  mov al, [si]
  mov word[es:di], ax
  call delay
  add di, 2
  inc si
  cmp byte [si], 0
  jne wisdom_l5

 popa
 ret

;------------;
 
draw_boundary

  pusha

   mov ax, 0xb800
   mov es, ax
   mov ax, 0 
   mov di, 164
   mov ax, 0x095F

   boundary_b1:

   mov word [es:di], ax
   call delay
   add di, 2
   cmp di, 314
   jnz boundary_b1

   ;mov di, 400 
   ;mov word[es:di], 0x097C
   mov di, 240 
   mov word[es:di], 0x097C

   mov di, 170               ; player one's loc
   mov si, p1

   mov ah, 0x07
 
  boundary_l2:

 mov al, [si]
 mov word[es:di], ax
 add di, 2
 inc si
 cmp byte [si], 0
 jne boundary_l2


   mov di, 250                ; player two's loc
   mov si, p2

   mov ah, 0x07
 
  boundary_l3:

 mov al, [si]
 mov word[es:di], ax
 add di, 2
 inc si
 cmp byte [si], 0
 jne boundary_l3

  popa
  ret

;----------------;

display_player_data:
    pusha

    mov ax, 0xb800
    mov es, ax

    mov di, 194

    ; Display Player 1's score
    mov al, [p1_score]        ; Load Player 1's score
    add al, '0'               ; Convert to ASCII (e.g., 0 -> '0', 1 -> '1')
    mov byte [es:di], al      ; Display the score as a character
    inc di

    mov di, 274

    ; Display Player 2's score
    mov al, [p2_score]        ; Load Player 2's score
    add al, '0'               ; Convert to ASCII (e.g., 0 -> '0', 1 -> '1')
    mov byte [es:di], al      ; Display the score as a character

    popa
    ret

epicly_drawing_boundary:

    pusha

    mov ax, 0xb800
    mov es, ax

    mov di, 3760
    mov si, 3760

 epic_B1:
    mov word [es:di], 0x095F
    mov word [es:si], 0x095F
    sub di, 2
    add si, 2
    call delay
    cmp di, 3680
    cmp si, 3836
    jne epic_B1

 epic_B2:
    mov word [es:di], 0x097C
    mov word [es:si], 0x097C
    sub di, 160
    sub si, 160
    call delay
    cmp di, 160
    cmp si, 316
    jne epic_B2

    popa
    ret

;-----------------------;


; Subroutine to handle pausing and resuming the game
pause_game:
    mov ah, 0x00             ; BIOS: Wait for key press
    int 0x16                 ; Call BIOS to get key
    cmp al, 0x50             ; Check if the pressed key is 'P' (0x50 is the ASCII value of 'P')
    je pause_game_loop       ; If 'P' is pressed, enter pause state

    cmp al, 0x75             ; Check if the pressed key is 'U' (0x75 is the ASCII value of 'u')
    je unpause_game          ; If 'U' is pressed, unpause the game

    jmp pause_game           ; Continue waiting for a key press

 pause_game_loop:
    mov ah, 0x00             ; BIOS: Wait for key press
    int 0x16                 ; Call BIOS to get key
    cmp al, 0x75             ; Check if the pressed key is 'U' (0x75 is the ASCII value of 'u')
    je unpause_game          ; If 'U' is pressed, unpause the game
    jmp pause_game_loop      ; Keep waiting for 'U' to unpause

 unpause_game:
    ret                      ; Return and continue gameplay


;-----------------------;

check_epic_winner:
    ; Check if Player 1's score is 5
    mov al, [p1_score]        ; Load Player 1's score
    cmp al, 5               ; Compare with the winning score (5)
    je player_1_won          ; Jump if Player 1 has won

    ; Check if Player 2's score is 5
    mov al, [p2_score]        ; Load Player 2's score
    cmp al, 5                ; Compare with the winning score (5)
     je player_2_won           ; Jump if Player 2 has won

    ; No winner yet, continue the game
    ret

player_1_won:

 call play_beep

 mov  byte [fill_pattern_running], 0 
 call epic_clrscr
 mov ax, 0xb800
 mov es, ax
 mov si, over
 mov ax, 0 
 mov di, 1990
 
 mov ah, 0x04
 
 won_l1:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne won_l1

 mov di, 2140

 mov si, p1_win
 mov ah, 0x07
 
 won_l2:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne won_l2

 jmp end

player_2_won:

 call play_beep

 mov  byte [fill_pattern_running], 0 
 call epic_clrscr
 mov ax, 0xb800
 mov es, ax
 mov si, over
 mov ax, 0 
 mov di, 1990
 
 mov ah, 0x04
 
 won2_l1:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne won2_l1

 mov di, 2140

 mov si, p2_win
 mov ah, 0x07
 
 won2_l2:
 
 mov al, [si]
 mov word[es:di], ax
 add di, 2
 call shorter_delay
 call shorter_delay
 inc si
 cmp byte [si], 0
 jne won2_l2

 jmp end

; Subroutine to play a custom beep using delay
play_beep:
    mov cx, 10000         ; Number of toggles
tone_loop:
    in al, 0x61           ; Read port 0x61
    xor al, 2             ; Toggle bit 1 (speaker)
    out 0x61, al          ; Write back to port 0x61
    call sound_delay      ; Call delay subroutine
    loop tone_loop
    ret

end:
    mov ax, 0x4c00
    int 0x21  