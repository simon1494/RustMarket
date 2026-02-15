@echo off
cd C:\Users\simon\Documents\GitHub\RustMarket

set /p CONTRACT=Ingrese el contract address: 

REM registro a SIMON como usuario
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message registrar_usuario ^
--args "\"Simon Bierozko\"" "\"simon.bierozko@demo.com\"" Ambos ^
--value 0 ^
-y

REM registro a PEDRO como usuario
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "cargo truth mechanic error wrestle noise cave awful exercise detail tide upset" ^
--execute ^
--message registrar_usuario ^
--args "\"Pedro Martinez\"" "\"pedro@demo.com\"" Ambos ^
--value 0 ^
-y

REM registro a MARIA como usuario
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "virtual jeans muscle share welcome teach topple butter explain ensure control cat" ^
--execute ^
--message registrar_usuario ^
--args "\"Maria Hernandez\"" "\"mari@demo.com\"" Ambos ^
--value 0 ^
-y

REM registro a Carlos como usuario
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "segment hunt roof write mixed special spell run wait ticket pen response" ^
--execute ^
--message registrar_usuario ^
--args "\"Carlos Toledo\"" "\"cacho@demo.com\"" Ambos ^
--value 0 ^
-y

REM SIMON crea categoria ALIMENTOS
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message registrar_categoria ^
--args "\"alimentos\"" ^
--value 0 ^
-y

REM SIMON crea categoria ELECTRONICA
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message registrar_categoria ^
--args "\"electronica\"" ^
--value 0 ^
-y

REM SIMON crea categoria BAZAR
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message registrar_categoria ^
--args "\"bazar\"" ^
--value 0 ^
-y

REM SIMON crea categoria DEPORTES
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message registrar_categoria ^
--args "\"deportes\"" ^
--value 0 ^
-y

REM SIMON crea categoria DECO
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message registrar_categoria ^
--args "\"deco\"" ^
--value 0 ^
-y

REM SIMON crea producto BANANA (1000 unidades)
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message crear_producto ^
--args "\"Banana\"" "\"Banana ecuatoriana\"" "\"alimentos\"" 1000 ^
--value 0 ^
-y

REM SIMON crea producto IPHONE X (2000 unidades)
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message crear_producto ^
--args "\"Iphone X\"" "\"Un buen celular\"" "\"electronica\"" 2000 ^
--value 0 ^
-y

REM SIMON crea producto PALITOS CHINOS (3000 unidades)
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message crear_producto ^
--args "\"Palitos Chinos\"" "\"Como un tenedor, pero peor\"" "\"bazar\"" 3000 ^
--value 0 ^
-y

REM SIMON publica 100 BANANAS a precio 50
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "alone twice window shove awake acid win manage subway behave used bless" ^
--execute ^
--message crear_publicacion ^
--args 0 100 50 ^
--value 0 ^
-y

REM PEDRO publica 200 IPHONE X a precio 70
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "cargo truth mechanic error wrestle noise cave awful exercise detail tide upset" ^
--execute ^
--message crear_publicacion ^
--args 1 200 70 ^
--value 0 ^
-y

REM MARIA publica 500 PALITOS CHINOS a precio 8
cargo contract call ^
--url wss://smiling-evenly-crawdad.ngrok-free.app ^
--contract %CONTRACT% ^
--suri "virtual jeans muscle share welcome teach topple butter explain ensure control cat" ^
--execute ^
--message crear_publicacion ^
--args 2 500 8 ^
--value 0 ^
-y


pause
