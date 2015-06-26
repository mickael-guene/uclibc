/* Copyright (C) 2010-2015 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */

/* Out-of-line syscall stub.  We expect the system call number in ip
   and return the raw result in r0.  No registers are clobbered.
   We could avoid using the stack for this, but the goal is accurate
   unwind information - and while there is a reserved prefix in the
   ARM unwind tables for register to register moves, the actual opcodes
   are not defined.  */

#if defined(__thumb__)
	.thumb
	.syntax unified
	.hidden __libc_do_syscall

    .globl __libc_do_syscall
    .type __libc_do_syscall, %function
    .align 4
__libc_do_syscall:
	push	{r7, lr}
	mov	r7, ip
	swi	0x0
	pop	{r7, pc}
    .size __libc_do_syscall, . -__libc_do_syscall

#endif /* __thumb__ */
