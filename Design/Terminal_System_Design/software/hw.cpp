#include "hw.h"

void *virtual_base = NULL;
volatile unsigned int *LED = NULL;
volatile unsigned int *sysID = NULL;
volatile unsigned int *CTRL = NULL;
int fd = 0;

bool init_hps()
{
    if ((fd = open("/dev/mem", (O_RDWR | O_SYNC))) == -1)
    {
        printf("ERROR: could not open \"/dev/mem\"...\n");
        return false;
    }

    virtual_base = mmap(NULL, HW_REGS_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

    if (virtual_base == MAP_FAILED)
    {
        printf("ERROR: mmap() failed...\n");
        close(fd);
        return false;
    }

    LED    = (unsigned int *)((unsigned int)virtual_base + ((0xC0000000 + 0x00010000) & (HW_REGS_MASK)));
    sysID  = (unsigned int *)((unsigned int)virtual_base + ((0xC0000000 + 0x00020000) & (HW_REGS_MASK)));
    CTRL   = (unsigned int *)((unsigned int)virtual_base + ((0xC0000000 + 0x00000000) & (HW_REGS_MASK)));
    
    return true;
}



bool term_hps()
{
    if (munmap(virtual_base, HW_REGS_SPAN) != 0)
    {
        printf("ERROR: munmap() failed...\n");
        close(fd);
        return false;
    }

    close(fd);
    return true;
}



bool write_data(unsigned int addrOffset, unsigned int data)
{
    if (ADDR_sys_ctrl_regs <= addrOffset && addrOffset < ADDR_sys_ctrl_regs+300) 
    {
        *(CTRL + addrOffset) = data;
        while(!read_data(ADDR_wr_over)); 
    }
    else 
    {
        *(CTRL + addrOffset) = data;
    }
    //printf("[%d] = %d\n",addrOffset, data);
    return true;
}




unsigned int read_data(unsigned int addrOffset)
{
    return *(CTRL + addrOffset);
}