#ifndef __CLI_COMMON_H
#define __CLI_COMMON_H

#include <stdint.h>
#include <vector>


void *map_addr(uint32_t address, uint32_t size, int *mem_fd);
void unmap_addr(int mem_fd);

std::vector<std::vector<int>> load_arrays(const char *file);
std::vector<int> load_file(const char *file);

#endif // __CLI_COMMON_H
