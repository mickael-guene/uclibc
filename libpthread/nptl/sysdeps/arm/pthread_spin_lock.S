/* Copyright (C) 2005 Free Software Foundation, Inc.
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
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#include <sysdep.h>

	.text
	.align	4

ENTRY (pthread_spin_lock)
#if 0
	mov	r1, #1
1:	swp	r2, r1, [r0]
	teq	r2, #0
	bne	1b
	mov	r0, #0
	PSEUDO_RET_NOERRNO
#else
// v6 and later ony
    mov r2, #1              // lock value is 1
1:  ldrex r1, [r0]          // read lock value
    teq r1, #0              // test if lock taken
    itt eq
    strexeq r1, r2, [r0]    // try to get lock in case lock not yet taken
    teqeq r1, #0            // test if we get lock successfully
    it ne
    bne 1b
    mov	r0, #0
	PSEUDO_RET_NOERRNO
#endif
END (pthread_spin_lock)
