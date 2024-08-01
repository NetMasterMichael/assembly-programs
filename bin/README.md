# Assembling programs into raw binaries
These programs have been programmed to execute directly on the bare metal, whether that be a virtual machine or a physical machine. Rather than interrupting the OS kernel to request system calls, we are interrupting the BIOS to execute certain functions that end up reading and writing bytes, to and from locations.

There are several software utilities required:
- `nasm` - Used to assemble the programs into binaries
- `QEMU` - Used for executing binaries in a virtual machine
- `dd` - Used to write the binaries directly to a USB drive
## 1. Installing Essential Software
You can install `nasm` and `QEMU` using your package manager of choice. `apt` is shown below.
```bash
sudo apt update
sudo apt install nasm
sudo apt install qemu
```
`dd` is included in the GNU Core Utilities (or simply `coreutils`), so this should already be present on your system.

Note: `QEMU` is quite a large download! At the time of writing, it is 947MB in size.
## 2. Assembling
You can use `nasm` to assemble any program into its raw binary using the command below.
```
nasm -f bin -o program.bin program.asm
```
Linking is not necessary for raw binaries because these are intended to be executed directly on the bare metal, rather than in the user space of an OS. This means that there are no unresolved references to system calls and libraries that need to be linked together by a linker first.
## 3. Executing in a Virtual Machine
We can use `QEMU` to execute these binaries in a virtual machine. After assembling a program, you can spin up a VM and start executing the binary in it using the command below.
```bash
qemu-system-x86_64 -drive format=raw,file=program.bin
```
This will open a VM in a new window and you will see the program executing.
## 4. Executing on Real Hardware
So you want to go the extra step and execute one of these programs on some real hardware? Here's how!

### ⚠️ Warning ⚠️ 
Although most BIOS software will generally have the same common interrupts, this will vary between hardware. Results on your own hardware may vary and unpredictable behaviour can occur!

You will need:
- A USB drive (ALL DATA ON HERE WILL BE LOST to formatting, please back up any important data first)
- A computer that supports booting Legacy (or also called CSM) bootloaders

### 4.1. Identifying your USB drive
After assembling a program into a binary, insert a USB drive into your system. It is not necessary to mount the drive.

Run the command below to list the attached drives detected on your system.
```bash
sudo fdisk -l
```
In this list, your USB drive will be present. You can find it by searching through the list for the drive with the matching capacity of your USB drive. It will have a name as shown below.
```
/dev/sdX
```
Where `X` will be a letter of the alphabet such as a, b, c, etc. Once you have identified your drive, remember the device identifier or write it down.

Please ensure that you have the correct drive. If you select the wrong drive, I am not responsible for any data loss that is caused! If you are unsure, you could unplug it and run `sudo fdisk -l` again to see that it disappears, then plug it in and repeat to see it come back.
### 4.2. Writing the binary to your USB drive
Now that you know the path to your USB drive, you can write it using the commands below.
```bash
sudo dd if=program.bin of=/dev/sdX bs=512 count=1
sudo sync
```
This will write the program to the first sector (512 bytes) of your USB drive. We use `sudo sync` afterwards to flush any write buffers and ensure all of the bytes have been written.
### 4.3. Booting the USB drive
Finally, you can now boot the USB drive and execute the program on bare metal. If you've ever booted a Windows Setup formatted as Legacy/CSM before, the process is the same.
1. Ensure that Legacy/CSM booting is enabled on your system
2. Enter your boot menu upon startup (usually by pressing F12 or F10)
3. Select your USB drive
4. Watch the program execute! (again, it may behave unpredictably depending on your system)
## Future Idea: ISO Generation
One idea I want to explore in the future is generating an ISO, so that a utility such as Rufus could be used to image a USB drive. Although I did get this partially working, I was not satisfied with the results, so I have excluded such instructions from this readme. 

The biggest issue I encountered was that the program was not written to the first sector of the USB drive. This included the 0x55AA magic bytes at the end of the first sector that mark a drive as bootable to the BIOS. This meant that when a drive was imaged with the program inside an ISO file, my programs actually didn't boot/execute on any systems except for VMs. Using the `dd` tool works around this problem, since it writes the file byte-for-byte directly to the first sector of the drive.

I may also explore writing my own ISO imaging tool, as the [El Torito Specification](https://pdos.csail.mit.edu/6.828/2014/readings/boot-cdrom.pdf) for the ISO 9660 format is surprisingly not too complex. That is a project for another day!
