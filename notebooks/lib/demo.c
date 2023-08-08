#include<stddef.h>

int c_sumtil(size_t n) {
	int s = 0;
	for (size_t i=1; i<=n; i++) {
		s += i;
	}
	return s;
}
