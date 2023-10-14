# pcie_mem_size_calc
Calculate the ROM memory size of any PCIe device

## Why do this?
While learning about PCIe devices, I came across Base Address Registers. These exist in the PCIe configuration space, which is a reserved memory inside the PCIe device. The BAR0 stores an address. This address in memory is where the PCIe device is mapped to.

In short, it is a way to access memory registers of any PCIe device from user space.

According to [this wiki page](https://wiki.osdev.org/PCI#Address_and_size_of_the_BAR) 

> To determine the amount of address space needed by a PCI device, you must save the original value of the BAR, write a value of all 1's to the register, then read it back. The amount of memory can then be determined by masking the information bits, performing a bitwise NOT ('~' in C), and incrementing the value by 1. The original value of the BAR should then be restored. The BAR register is naturally aligned and as such you can only modify the bits that are set. For example, if a device utilizes 16 MB it will have BAR0 filled with 0xFF000000 (0x1000000 after decoding) and you can only modify the upper 8-bits.

## Improvements to be made
- Check number of memories present
- Check type of memory (32-bit or 64-bit or I/O)
- Report complete information according to the above points
