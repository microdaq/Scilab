/* mdaq_file.h -- File access driver for MicroDAQ device
 *
 * Copyright (C) 2013 Embedded Solutions
 * All rights reserved.
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef MDAQFILE_H_
#define MDAQFILE_H_

#include <string.h>

#define	O_RDONLY	00000000		/* open for reading only */
#define	O_WRONLY	00000001		/* open for writing only */
#define	O_RDWR		00000002		/* open for reading and writing */

#define	O_NONBLOCK	00004000		/* no delay */
#define	O_APPEND	00002000		/* set append mode */
#define	O_CREAT		00000100		/* create if nonexistant */
#define	O_TRUNC		00001000		/* truncate to zero length */
#define	O_EXCL		00000200		/* error if already exists */
#define O_DIRECT    00040000        /* direct disk access hint */

int mdaq_file_init( void );
int mdaq_file_open(const char *name, int flags);
int mdaq_file_close(int fd);
int mdaq_file_write(int fd, const void *buf, size_t len);
int mdaq_file_writeb(int fd, const void *buf, size_t len); 	/* blocking version of mdaq_file_write */
int mdaq_file_lseek(int fd, long offset, int whence);
int mdaq_file_flush(int sockfd);
int mdaq_file_flush2(int fd); /* Wait for end of last operation i.e file_write (nonblocking) */

#endif /* MDAQFILE_H_ */
