#include <stdio.h>
#include <libssh2.h>

int main() {
	printf("libssh2 version: %s \n", libssh2_version(0));
	return 0;
}

/* gcc main.c -lssh2 -o libssh2-version */
