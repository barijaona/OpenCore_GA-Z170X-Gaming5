/*
 * Fix interruption of deep sleep caused by XDCI device not present in IOService
 * As suggested in https://www.tonymacx86.com/threads/usb-devices-ejected-after-sleep.223128/post-1513847
 */
DefinitionBlock ("", "SSDT", 2, "hack", "XDCISLEEP", 0x00000000)
{
    External(_SB.PCI0.XDCI, DeviceObj)
    External(GPRW, MethodObj)    // 2 Arguments (from opcode)

    Scope (_SB.PCI0.XDCI)
    {
        // In DSDT, native _PRW is renamed to XPRW through binpatch
        // As a result, calls to _PRW land here
        // The purpose of this implementation is to avoid "instant wake"
        // by returning 0 in the second position (sleep state supported)
        Method (_PRW, 0, NotSerialized)  // _PRW: Power Resources for Wake
        {
            If (_OSI ("Darwin"))
            {
                Return (GPRW (0x6D, 0x0))
            }
            Else
            {
                Return (GPRW (0x6D, 0x04))
            }
        }
    }
}

