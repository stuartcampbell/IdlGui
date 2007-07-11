/** Author: Wes Kendall
 *  Date: 06-18-07
 *  \file nexus_util.cpp
 *  \brief A bunch of wrapper functions for the nexus api. These
 *         functions are enclosed in a class and do all the 
 *         necessary error checking.
 */

#include "nexus_util.hpp"
#include <string>
#include <stdexcept>
#include <vector>

using std::runtime_error;
using std::string;
using std::vector;

template 
void NexusUtil::put_data_with_slabs<uint32_t>(vector<uint32_t> & nx_data,
                                              int block_size);

NexusUtil::NexusUtil(const string &out_path,
                     e_nx_access file_access)
{
  if (out_path == "")
    {
      throw runtime_error("Must specify a file to open");
    }

  if (NXopen(out_path.c_str(), 
      (NXaccess)file_access, &(this->file_id)) != NX_OK)
    {
      throw runtime_error("Failed to open nexus file: "+out_path);
    }
}

NexusUtil::~NexusUtil(void)
{
  if (NXclose(&(this->file_id)) != NX_OK)
    {
      throw runtime_error("Failed to close nexus file");
    }
}

void NexusUtil::make_group(const string &name, const string &path)
{
  if (name == "")
    {
      throw runtime_error("No group name specified");
    }

  if (path == "")
    {
      throw runtime_error("No path name specified");
    }

  if (NXmakegroup(this->file_id, name.c_str(), path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to make group: "+name);
    }
}

void NexusUtil::open_group(const string &name, const string &path)
{
  if (name == "")
    {
      throw runtime_error("No group name specified");
    }

  if (path == "")
    {
      throw runtime_error("No path name specified");
    }

  if (NXopengroup(this->file_id, name.c_str(), path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: entry");
    }
}

void NexusUtil::close_group(void)
{
  if (NXclosegroup(this->file_id) != NX_OK)
    {
      throw runtime_error("Failed to close group");
    }
}

void NexusUtil::open_path(const string &path)
{
  if (path == "")
    {
      throw runtime_error("No path name specified");
    }
  
  if (NXopenpath(this->file_id, path.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open group: "+path);
    }
}

void NexusUtil::make_data(const string &name, 
                          int nexus_data_type, int rank, 
                          int *dimensions)
{
  if (name == "")
    {
      throw runtime_error("No data name specified");
    }
 
  if (dimensions == NULL)
    {
      throw runtime_error("Invalid dimensions");
    }

  if (NXmakedata(this->file_id, name.c_str(),
                 nexus_data_type, rank, dimensions) != NX_OK)
    {
      throw runtime_error("Failed make data: "+name);
    }
}

void NexusUtil::open_data(const string &name)
{
  if (name == "")
    {
      throw runtime_error("No data name specified");
    }

  if (NXopendata(this->file_id, name.c_str()) != NX_OK)
    {
      throw runtime_error("Failed to open data: "+name);
    }
}

void NexusUtil::put_data(void *nx_data)
{
  if (nx_data == NULL)
    {
      throw runtime_error("No data specified");
    }

  if (NXputdata(this->file_id, nx_data) != NX_OK)
    {
      throw runtime_error("Failed to create data");
    }
}

template <typename NumT>
void NexusUtil::put_data(const vector<NumT> & nx_data)
{
  if (nx_data.empty())
    {
      throw runtime_error("No data specified");
    }

  if (NXputdata(this->file_id, &(nx_data[0])) != NX_OK)
    {
      throw runtime_error("Failed to create data");
    }
}

void NexusUtil::close_data(void)
{
  if (NXclosedata(this->file_id) != NX_OK)
    {
      throw runtime_error("Failed to close data");
    }
}

void NexusUtil::put_attr(const string &name, void *value, 
                          int length, int nx_type)
{
  if (name == "")
    {
      throw runtime_error("No attribute name specified");
    }

  if (value == NULL)
    {
      throw runtime_error("No attribute specified");
    }

  if (NXputattr(this->file_id, name.c_str(),
                value, length,
                nx_type) != NX_OK)
    {
      throw runtime_error("Failed to create attribute: "+name);
    }
}

void NexusUtil::put_attr(const string &name, const string &value)
{
  if (name == "")
    {
      throw runtime_error("No attribute name specified");
    }

  if (value == "")
    {
      throw runtime_error("No attribute value specified");
    }

  string nx_value(value);
  if (NXputattr(this->file_id, name.c_str(),
                &(nx_value[0]), nx_value.length(),
                NX_CHAR) != NX_OK)
    {
      throw runtime_error("Failed to create attribute: "+name);
    }
}

template <typename NumT>
void NexusUtil::put_slab(vector<NumT> & nx_data, int start, 
                         int block_size)
{
  if (nx_data.empty())
    {
      throw runtime_error("No data specified");
    }

  if (block_size <= 0)
    {
      throw runtime_error("Block size must be > 0");
    }

  if (NXputslab(this->file_id, &(nx_data[start]), &start, 
                &block_size) != NX_OK)
    {
      throw runtime_error("Failed to create data chunk");
    }
}

template <typename NumT>
void NexusUtil::put_data_with_slabs(vector<NumT> & nx_data, 
                                    int block_size)
{
  if (nx_data.empty())
    {
      throw runtime_error("No data specified");
    }
  
  if (block_size <= 0)
    {
      throw runtime_error("Block size must be > 0");
    }
  
  int data_size = nx_data.size();
  for (int i = 0; i < data_size; i+=block_size)
    {
      if (i + block_size >= data_size)
        {
          block_size = data_size - i;
        }
      if (NXputslab(this->file_id, &(nx_data[i]), &i,
                    &block_size) != NX_OK)
        {
          throw runtime_error("Failed to create data chunk");
        }
    }
}

void NexusUtil::put_slab(void *nx_data, int *start, int *size)
{
  if (nx_data == NULL)
    {
      throw runtime_error("No data specified");
    }

  if (start == NULL)
    {
      throw runtime_error("Invalid start index");
    }

  if (size == NULL)
    {
      throw runtime_error("Invalid size");
    }

  if (NXputslab(this->file_id, nx_data, start, size) != NX_OK)
    {
      throw runtime_error("Failed to create data chunk");
    }
}

void NexusUtil::get_data(void *nx_data)
{
  if (nx_data == NULL)
    {
      throw runtime_error("Invalid data block");
    }

  if (NXgetdata(this->file_id, nx_data) != NX_OK)
    {
      throw runtime_error("Failed to get data");
    }
}

void NexusUtil::get_slab(void *nx_data, int *start, int *size)
{
  if (nx_data == NULL)
    {
      throw runtime_error("Invalid data block");
    }

  if (start == NULL)
    {
      throw runtime_error("Invalid start index");
    }
  
  if (size == NULL)
    {
      throw runtime_error("Invalid size");
    }

  if (NXgetslab(this->file_id, nx_data, start, size) != NX_OK)
    {
      throw runtime_error("Failed to get slab");
    }
}

void NexusUtil::malloc(void **nx_data, int rank, int *dimensions,
                       int nexus_data_type)
{
  if (nx_data == NULL)
    {
      throw runtime_error("Can't malloc NULL pointer");
    }
  
  if (dimensions == NULL)
    {
      throw runtime_error("Invalid dimensions");
    }
  
  if (NXmalloc(nx_data, rank, dimensions, nexus_data_type) != NX_OK)
    {
      throw runtime_error("Malloc failure");
    }
}

void NexusUtil::free(void **nx_data)
{
  if (nx_data != NULL)
    {
      if (NXfree(nx_data) != NX_OK)
        {
          throw runtime_error("Free failure");
        }
    }
}

void NexusUtil::get_info(int *rank, int *dimensions, 
                         int *nexus_data_type)
{
  if (rank == NULL)
    {
      throw runtime_error("Invalid rank");
    }

  if (dimensions == NULL)
    {
      throw runtime_error("Invalid dimensions");
    }

  if (nexus_data_type == NULL)
    {
      throw runtime_error("Invalid nexus data type");
    }

  if (NXgetinfo(this->file_id, rank, dimensions, 
                nexus_data_type) != NX_OK)
    {
      throw runtime_error("Failed to get data information");
    }
}
