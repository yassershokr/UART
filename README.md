# UART
🔹 **UART Module:** This project involved creating a UART module from the ground up, a vital component in many communication systems.

🔹 **Transmitter & Receiver:** The core of the UART module comprises a transmitter and receiver, each featuring four distinct states: 
   - **Idle:** The initial state where the transmitter and receiver are waiting for data.
   - **Start:** The state where the transmitter begins sending data and the receiver prepares to receive it.
   - **Transmit:** During this state, data is transmitted bit by bit from the transmitter to the receiver.
   - **Stop:** The final state where the transmitter and receiver conclude the data transmission.

These four states play a crucial role in ensuring reliable serial data communication.

🔹 **FIFO (First-In-First-Out) Buffer:** To efficiently manage data, I integrated a FIFO buffer into the design. This buffer ensures seamless data flow between the transmitter and receiver, enhancing overall system performance.

🔹 **Baud Rate Generator:** Setting the correct baud rate is essential in UART communication. I incorporated a baud rate generator, allowing for flexible communication at various data rates as per project requirements.
