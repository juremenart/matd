#include <cstdio>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <algorithm>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <experimental/filesystem>

namespace fs = std::experimental::filesystem;

#define DEBUG

void *map_addr(uint32_t address, uint32_t size, int *mem_fd)
{
    void *page_ptr;
    long page_addr, page_off, page_size = sysconf(_SC_PAGESIZE);

    *mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if(*mem_fd < 0)
    {
        fprintf(stderr, "error in opening /dev/mem\n");
        return NULL;
    }

    page_addr   = address & (~(page_size-1));
    page_off    = address - page_addr;
    page_ptr    = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED,
                       *mem_fd, page_addr);
    if((void*)page_ptr == MAP_FAILED)
    {
        fprintf(stderr, "error in mmap()\n");
        return NULL;
    }

    return page_ptr + page_off;
}

void unmap_addr(int mem_fd)
{
    if(mem_fd < 0)
    {
        return;
    }

    close(mem_fd);
}

std::vector<std::vector<int>> load_arrays(const char *in_dir)
{
    std::vector<std::string> files;
    std::vector<std::vector<int>> data;

    for (const auto & entry : fs::directory_iterator(std::string(in_dir)))
        files.push_back(entry.path());

    std::sort(files.begin(), files.end());

    printf("Number of files: %d\n", files.size());

    // load array + delay
    for(auto i = 0; i < files.size(); i++)
    {
        std::string line;
        std::ifstream infile(files[i]);
        int ln = 0;
#ifdef DEBUG
        printf("Loading file: %s\n", files[i].c_str());
#endif
        data.push_back(std::vector<int>());

        while(std::getline(infile, line))
        {
            std::istringstream iss(line);

            for(int k = 0; k < 8; k++)
            {
                int int_data;
                iss >> int_data;
                data[i].push_back(int_data);
            }
            ln++;
        }
    }

    return data;
}

std::vector<int> load_file(const char *file)
{
    std::vector<int> data;
    std::string line;
    std::ifstream infile(file);
    int ln = 0;

#ifdef DEBUG
    printf("Loading file: %s\n", file);
#endif

    while(std::getline(infile, line))
    {
        std::istringstream iss(line);

        for(int k = 0; k < 8; k++)
        {
            int int_data;
            iss >> int_data;
            data.push_back(int_data);
        }
        ln++;
    }

    return data;
}

