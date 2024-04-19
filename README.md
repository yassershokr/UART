# UART
### In this repo i implemented the UART using system verilog
 UART stands for Universal Asynchronous Receiver/Transmitter. It’s not a communication protocol like SPI and I2C, but rather a physical circuit found in microcontrollers or as a stand-alone integrated circuit (IC). The primary purpose of UART is to transmit and receive serial data
it is a popular communication protocol used for serial communication between microcontrollers, sensors, and other electronic devices. It operates asynchronously, meaning that data is transmitted without the need for a shared clock signal between the sender and receiver. UART communication typically involves four states on the transmitter side: idle, start, transmit, and stop; and four states on the receiver side: idle, start, receive, and stop. Data transmission in UART occurs in a serial manner, with each byte being transmitted or received one bit at a time. A typical data packet in UART consists of a start bit, followed by the actual data bits, and ends with one or more stop bits. To enhance data handling and transmission efficiency, UART often incorporates FIFO (First In, First Out) buffers, allowing multiple bytes to be queued for transmission or reception. Additionally, UART systems utilize a baud rate generator to set the transmission speed, determining the rate at which bits are sent or received over the communication channel."

### The design consist of 

#### 1-transimeter
#### 2-reciever
#### 3-FIFO
#### 4-baud rate genrator 

##### as shown in this photo:

![Screenshot 2024-04-14 161444](https://github.com/yassershokr/UART/assets/128966281/e7e20a59-84f6-4b6c-a316-38fb6afecfe5)
