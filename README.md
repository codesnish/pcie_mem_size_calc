# pcie_mem_size_calc
Calculate the ROM memory size of any PCIe device

# Why do this?
While learning about PCIe devices, I came across Base Address Registers. These exist in the PCIe configuration space, which is a reserved memory inside the PCIe device. The BAR0 stores an address. This address in memory is where the PCIe device is mapped to.
