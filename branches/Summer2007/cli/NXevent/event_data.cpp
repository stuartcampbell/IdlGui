/**
 * \file event_data.cpp
 * \brief The implementation for the EventData
 *        class. For any documentation of the
 *        functions, look at event_data.hpp.
 */

#include "event_data.hpp"
#include "event2nxl.hpp"
#include <fstream>
#include <stdexcept>
#include <vector>
#include <iostream>
#include <sstream>
#include <ctime>

using std::stringstream;
using std::cout;
using std::endl;
using std::vector;
using std::string;
using std::runtime_error;
using std::ifstream;

// Declaring these functions prevent from having to include 
// event_data.cpp in event_data.hpp
template 
void EventData<uint32_t>::read_data(const string & event_file,
                                    const string & pulse_id_file,
                                    const string & bank_file);

template 
void EventData<uint32_t>::write_nexus_file(NexusUtil & nexus_util,
                                           const string & pulse_id_file);

template 
void EventData<uint32_t>::write_nexus_file(NexusUtil & nexus_util);

template 
void EventData<uint32_t>::read_data(const string & event_file,
                                    const string & bank_file);

template 
void EventData<uint32_t>::create_pixel_map(const string & mapping_file);

template 
EventData<uint32_t>::EventData();

template 
EventData<uint32_t>::~EventData();

template<typename NumT>
EventData<NumT>::EventData()
{
}

template<typename NumT>
EventData<NumT>::~EventData()
{
}

template<>
inline e_nx_data_type typename_to_nexus_type<uint32_t>()
{
  return UINT32;
}

template<>
inline e_nx_data_type typename_to_nexus_type<int32_t>()
{
  return INT32;
}

template<typename NumT>
inline e_nx_data_type typename_to_nexus_type()
{
  throw runtime_error("Invalid nexus data type");
}

template <typename NumT>
string EventData<NumT>::get_nx_data_name(const e_data_name nx_data_type)
{
  if (nx_data_type == TOF)
    {
      return "time_of_flight";
    }
  else if (nx_data_type == PIXEL_ID)
    {
      return "pixel_number";
    }
  else if (nx_data_type == PULSE_TIME)
    {
      return "pulse_time";
    }
  else if (nx_data_type == EVENTS_PER_PULSE)
    {
      return "events_per_pulse";
    }
  else 
    {
      throw runtime_error("Invalid enumerated data type");
    }
}

template <typename NumT>
void EventData<NumT>::write_attr(NexusUtil & nexus_util, 
                                 const string & attr_name,
                                 const string & attr_value,
                                 const e_data_name nx_data_name,
                                 const int bank_number)
{
  string data_name;
  
  // Fill in the values that are associated with the
  // given e_data_name
  data_name = this->get_nx_data_name(nx_data_name);  

  this->open_bank(nexus_util, bank_number);
  nexus_util.open_data(data_name);
  nexus_util.put_attr(attr_name, attr_value);
}

bool is_positive_int(string str)
{
  int size = str.length();
  if (size == 0)
    {
      return false;
    }
  if (str[0] == '0' && size > 1)
    {
      return false;
    }
  for (int i = 1; i < size; i++)
    {
      if (!isdigit(str[i]))
        {
          return false;
        }
    }
  return true;
}

int get_xml_int(xmlNodePtr node)
{
  if (node->children == NULL ||
      node->children->content == NULL)
    {
      throw runtime_error("In function get_xml_int: No number found");
    }
  else
    {
      string number_str(reinterpret_cast<const char *>
                        (node->children->content));
      // Make sure the bank number is a valid integer
      // before conversion
      if (!is_positive_int(number_str))
        {
          throw runtime_error("Invalid number: " + number_str);
        }
      return atoi(number_str.c_str());
    }
}

template <typename NumT>
void EventData<NumT>::create_arbitrary(xmlNodePtr bank_node,
                                       int bank_number)
{
  if (bank_node->children == NULL ||
      bank_node->children->content == NULL)
    {
      throw runtime_error("No data found in arbitrary list");
    }
  else
    {
      string number_str(reinterpret_cast<const char *>
                        (bank_node->children->content));
      int size = number_str.length();
      for (int i = 0; i < size; i++)
        {
          if (isdigit(number_str[i]))
            {
              string first_num;
              while(isdigit(number_str[i]))
                {
                  first_num.append(reinterpret_cast<const char *>(number_str[i]));
                  i++;
                }
            }
          else if (!isspace(number_str[i]))
            {
              throw runtime_error("Invalid character found in arbitrary data: "
                                  + number_str[i]);
            }
        }
    }
}

template <typename NumT>
void EventData<NumT>::create_cont_list(xmlNodePtr bank_node,
                                       int bank_number)
{
  int start = -1;
  int stop = -1;
  if (bank_number == -1)
    {
      throw runtime_error(
        "Bank number must be specified before step list");
    }
  xmlNodePtr cont_list_node;
  for (cont_list_node = bank_node->children; cont_list_node;
       cont_list_node = cont_list_node->next)
    {
      if (xmlStrcmp(cont_list_node->name,
          (const xmlChar *)"start") == 0)
        {
          start = get_xml_int(cont_list_node);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"stop") == 0)
        {
          stop = get_xml_int(cont_list_node);
        }
    }
  // Make sure the starting, and stopping numbers were
  // found for the continuous list and that the start isn't
  // >= to the stop
  if (start == -1)
    {
      throw runtime_error(
        "No start number found for step list");
    }
  if (stop == -1)
    {
      throw runtime_error(
        "No stop number found for step list");
    }
  if (start >= stop)
    {
      throw runtime_error(
        "Start number must be less than stop number");
    }
  if (stop > this->bank_map.size())
    {
      this->bank_map.resize(stop + 1);
    }
  // Fill in a step list for the bank map once
  // valid numbers have been found
  for (int i = start; i < stop; i++)
    {
      this->bank_map[i] = this->banks[bank_number];
    }
}

template <typename NumT>
void EventData<NumT>::create_step_list(xmlNodePtr bank_node,
                                       int bank_number)
{
  int start = -1;
  int stop = -1;
  int step = -1;
  if (bank_number == -1)
    {
      throw runtime_error(
        "Bank number must be specified before step list");
    }
  xmlNodePtr cont_list_node;
  for (cont_list_node = bank_node->children; cont_list_node;
       cont_list_node = cont_list_node->next)
    {
      if (xmlStrcmp(cont_list_node->name,
          (const xmlChar *)"start") == 0)
        {
          start = get_xml_int(cont_list_node);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"step") == 0)
        {
          step = get_xml_int(cont_list_node);
        }
      else if (xmlStrcmp(cont_list_node->name,
               (const xmlChar *)"stop") == 0)
        {
          stop = get_xml_int(cont_list_node);
        }
    }
    // Make sure the starting, stopping, and step numbers were
    // found for the step list and that the start isn't
    // >= to the stop
    if (start == -1)
      {
        throw runtime_error(
          "No start number found for step list");
      }
    if (stop == -1)
      {
        throw runtime_error(
          "No stop number found for step list");
      }
    if (step == -1)
      {
        throw runtime_error(
          "No step number found for step list");
      }
    if (start >= stop)
      {
        throw runtime_error(
          "Start number must be less than stop number");
      }
    if (stop > this->bank_map.size())
      {
        this->bank_map.resize(stop + 1);
      }
    // Fill in a step list for the bank map once
    // valid numbers have been found
    for (int i = start; i < stop; i+=step)
      {
        this->bank_map[i] = this->banks[bank_number];
      }
}

template <typename NumT>
void EventData<NumT>::parse_bank_file(const string & bank_file)
{
  xmlDocPtr doc = NULL;
  xmlLineNumbersDefault(1);
  doc = xmlReadFile(bank_file.c_str(), NULL, 0);
  if (doc == NULL)
    {
      throw runtime_error("Could not read bank configuration file: " 
                          + bank_file);
    }

  xmlNodePtr cur_node = xmlDocGetRootElement(doc);
  int max_bank_number = -1;
  int bank_number = -1;

  for (cur_node = cur_node->children; cur_node;
       cur_node = cur_node->next) 
    {
      xmlNodePtr bank_node;
      for (bank_node = cur_node->children; bank_node;
           bank_node = bank_node->next)
        {
          if (xmlStrcmp(bank_node->name, 
              (const xmlChar *)"number") == 0)
            {
              // When a valid bank number is found, push it on
              // the bank numbers vector
              bank_number = get_xml_int(bank_node);
              if (bank_number > max_bank_number) 
                { 
                  max_bank_number = bank_number;
                  this->banks.resize(max_bank_number + 1);
                }
              this->bank_numbers.push_back(
                bank_number);
              this->banks[bank_number] = new Bank<NumT>();
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"step_list") == 0)
            {
              create_step_list(bank_node, bank_number);
              break;
            }
          else if (xmlStrcmp(bank_node->name, 
                   (const xmlChar *)"continuous_list") == 0)
            {
              create_cont_list(bank_node, bank_number);
              break;
            }
          else if (xmlStrcmp(bank_node->name,
                   (const xmlChar *)"arbitrary") == 0)
            {
              create_arbitrary(bank_node, bank_number);
              break;
            }
        }
      bank_number = -1;
    }

  if (max_bank_number == -1)
    {
      throw runtime_error("No banks found in bank configuration");
    }

  xmlFreeDoc(doc);
  xmlCleanupParser();
}

template <typename NumT>
const string & EventData<NumT>::get_pulse_time_offset(void)
{
  if (this->pulse_time_offset.empty())
    {
      throw runtime_error("Pulse time offset hasn't been created");
    }
  else
    {
      return this->pulse_time_offset;
    }
}

template <typename NumT>
void EventData<NumT>::write_nexus_file(NexusUtil & nexus_util)
{
  // First layout the nexus file
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  int size = bank_numbers.size();
  for (int i = 0; i < size; i++)
    { 
      stringstream bank_num;
      bank_num << "bank" << this->bank_numbers[i];
      nexus_util.make_group(bank_num.str(), "NXevent_data");
      nexus_util.open_group(bank_num.str(), "NXevent_data");
      nexus_util.close_group();
    }
  nexus_util.close_group();
  // Write out each bank's information
  size = this->bank_numbers.size();
  for (int i = 0; i < size; i++)
    {
      if (this->banks[bank_numbers[i]]->tof.size() > 0)
        {
          this->write_data(nexus_util, TOF, this->bank_numbers[i]);
          this->write_data(nexus_util, PIXEL_ID, this->bank_numbers[i]);
          this->write_attr(nexus_util, "units", "10^-7second", 
                           TOF, this->bank_numbers[i]);
        }
    }
}

template <typename NumT>
void EventData<NumT>::write_nexus_file(NexusUtil & nexus_util, 
                                       const string & pulse_id_file)
{
  // First layout the nexus file
  nexus_util.make_group("entry", "NXentry");
  nexus_util.open_group("entry", "NXentry");
  int size = bank_numbers.size();
  for (int i = 0; i < size; i++)
    { 
      stringstream bank_num;
      bank_num << "bank" << this->bank_numbers[i];
      nexus_util.make_group(bank_num.str(), "NXevent_data");
      nexus_util.open_group(bank_num.str(), "NXevent_data");
      nexus_util.close_group();
    }
  nexus_util.close_group();
  
  // Write out each bank's information
  size = this->bank_numbers.size();
  for (int i = 0; i < size; i++)
    {
      if (this->banks[this->bank_numbers[i]]->tof.size() > 0)
        {
          this->write_data(nexus_util, TOF, this->bank_numbers[i]);
          this->write_data(nexus_util, PIXEL_ID, this->bank_numbers[i]);
          this->write_data(nexus_util, PULSE_TIME, this->bank_numbers[i]);
          this->write_data(nexus_util, EVENTS_PER_PULSE, this->bank_numbers[i]);
          this->write_attr(nexus_util, "units", "10^-7second", 
                           TOF, this->bank_numbers[i]);
          this->write_attr(nexus_util, "units", "10^-9second", 
                           PULSE_TIME, this->bank_numbers[i]);
          this->write_attr(nexus_util, "offset", this->get_pulse_time_offset(), 
                           PULSE_TIME, this->bank_numbers[i]);
        }
    }
}

template <typename NumT>
void EventData<NumT>::open_bank(NexusUtil & nexus_util,
                                const int bank_number)
{
  stringstream bank_num;
  bank_num << "/entry/bank" << bank_number;
  nexus_util.open_path(bank_num.str());
}

template <typename NumT>
void EventData<NumT>::write_private_data(NexusUtil & nexus_util,
                                         vector<NumT> & nx_data, 
                                         string & data_name,
                                         const int bank_number)
{
  int dimensions = nx_data.size();
  
  // Get the nexus data type of the template
  e_nx_data_type nexus_data_type = typename_to_nexus_type<NumT>();
  this->open_bank(nexus_util, bank_number);
  nexus_util.make_data(data_name, nexus_data_type, 1, &dimensions);
  nexus_util.open_data(data_name);
  nexus_util.put_data_with_slabs(nx_data, 16777215);
}

template <typename NumT>
void EventData<NumT>::write_data(NexusUtil & nexus_util, 
                                 const e_data_name nx_data_name,
                                 const int bank_number)
{
  string data_name;
  
  // Fill in the values that are associated with the 
  // given e_data_name
  data_name = this->get_nx_data_name(nx_data_name);
  if (nx_data_name == TOF)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->tof, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == PIXEL_ID)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->pixel_id, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == PULSE_TIME)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->pulse_time, 
                               data_name,
                               bank_number);
    }
  else if (nx_data_name == EVENTS_PER_PULSE)
    {
      this->write_private_data(nexus_util, 
                               this->banks[bank_number]->events_per_pulse, 
                               data_name,
                               bank_number);
    }
  else
    {
      throw runtime_error("Invalid enumerated data type");
    }
}
 
template <typename NumT>
void open_file_and_get_sizes(ifstream & fp,
                             const string & file_name,
                             size_t & file_size, 
                             size_t & buffer_size)
{
  if (file_name.empty())
    {
      throw runtime_error("Empty file name");
    }

  fp.open(file_name.c_str(), std::ios::binary);
  if(!(fp.is_open()))
    {
      throw runtime_error("Failed opening file: " + file_name);
    }

  fp.seekg(0, std::ios::end);
  file_size = fp.tellg() / sizeof(NumT);

  buffer_size = (file_size < BLOCK_SIZE) ?
                  file_size : BLOCK_SIZE;
}

template <typename NumT>
void EventData<NumT>::create_pixel_map(const string & mapping_file)
{
  size_t file_size;
  size_t buffer_size;
  ifstream file;
  open_file_and_get_sizes<NumT>(file,
                                mapping_file,
                                file_size,
                                buffer_size);
  
  // Go to the start of file and begin reading
  file.seekg(0, std::ios::beg);
  int32_t buffer[BLOCK_SIZE];
  size_t offset = 0;
  while(offset < file_size)
    {
      file.read(reinterpret_cast<char *>(buffer), 
                buffer_size * sizeof(NumT));

      // For each mapping index, map the pixel id
      // in the mapping file to that index
      for(size_t i = 0; i < buffer_size; i++)
        {
          this->pixel_id_map.push_back(*(buffer + i));
        }

      offset += buffer_size;

      // Make sure to not read past EOF
      if(offset + BLOCK_SIZE > file_size)
        {
          buffer_size = file_size - offset;
        }
    }

  // Close mapping file
  file.close();
}

string seconds_to_iso8601(uint32_t seconds)
{
  char date[100];
  // Since the times start at a different epoch (jan 1, 1990) than
  // the unix epoch (jan 1, 1970), add the number of seconds
  // between the epochs to use the ctime library
  const uint32_t epoch_diff = 631152000;
  time_t pulse_seconds = epoch_diff + seconds;
  struct tm *pulse_time = localtime(&pulse_seconds);
  strftime(date, sizeof(date), "%Y-%m-%dT%X-04:00", pulse_time);
  string time(date);
  return time;  
}

template <typename NumT>
void EventData<NumT>::read_data(const string & event_file, 
                                const string & bank_file)
{
  // Open the event file and get the file and buffer sizes
  size_t event_file_size;
  size_t event_buffer_size;
  ifstream event_fp; 
  open_file_and_get_sizes<NumT>(event_fp,
                                event_file,
                                event_file_size,
                                event_buffer_size);

  // Parse the bank file and fill in the banking map
  this->parse_bank_file(bank_file);

  // Go to the start of file and begin reading
  event_fp.seekg(0, std::ios::beg);
  NumT event_buffer[BLOCK_SIZE];
  size_t event_fp_offset = 0;
  while(event_fp_offset < event_file_size)
    {
      event_fp.read(reinterpret_cast<char *>(event_buffer), 
                    event_buffer_size * sizeof(NumT));

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(size_t event_i = 0; event_i < event_buffer_size; event_i+=2)
        {
          // Filter out error codes
          if ((*(event_buffer + event_i + 1) & ERROR) != ERROR)
            {
              // Use pointer arithmetic for speed
              Bank<NumT> *bank = this->bank_map[*(event_buffer + event_i + 1)];
             
              // Put the pixel ids and time of flights in their proper bank 
              bank->tof.push_back(*(event_buffer + event_i));
              bank->pixel_id.push_back(
                this->pixel_id_map[*(event_buffer + event_i + 1)]);
            }
        }

      event_fp_offset += event_buffer_size;

      // Make sure to not read past EOF
      if(event_fp_offset + BLOCK_SIZE > event_file_size)
        {
          event_buffer_size = event_file_size - event_fp_offset;
        }
    }
  // Close event file
  event_fp.close();
}

template <typename NumT>
void EventData<NumT>::read_data(const string & event_file, 
                                const string & pulse_id_file,
                                const string & bank_file)
{
  NumT event_buffer[BLOCK_SIZE];
  NumT pulse_buffer[BLOCK_SIZE];

  // Open the event file and determine file size and buffer size
  size_t event_file_size;
  size_t event_buffer_size;
  ifstream event_fp;
  open_file_and_get_sizes<NumT>(event_fp,
                                event_file,
                                event_file_size,
                                event_buffer_size);

  // Open the pulse id file and determine file size and buffer size
  size_t pulse_file_size;
  size_t pulse_buffer_size; 
  ifstream pulse_fp; 
  open_file_and_get_sizes<NumT>(pulse_fp,
                                pulse_id_file,
                                pulse_file_size,
                                pulse_buffer_size);

  // Get the first block from the pulse id file and read in the initial 
  // values
  pulse_fp.seekg(0, std::ios::beg);
  pulse_fp.read(reinterpret_cast<char *>(pulse_buffer), 
                pulse_buffer_size * sizeof(NumT));

  // Get the first time from the pulse id and use this as the offset
  NumT init_seconds = static_cast<NumT>(*(pulse_buffer + 1));
  this->pulse_time_offset = seconds_to_iso8601(init_seconds);

  // Get the initial time offset of the event
  NumT event_time_offset = static_cast<NumT>(*(pulse_buffer));  

  // Since the first pulse offset is zero and doesn't matter, skip to the 
  // next one and start with it.
  NumT pulse_index = static_cast<NumT>(*(pulse_buffer + 6));

  // Parse configuration file and read in the bank map
  this->parse_bank_file(bank_file);

  // Since 4 int32's have already been read in from the pulse buffer, set the 
  // initial value of the pulse buffer index to 4
  size_t pulse_buf_i = 4;
  size_t pulse_fp_offset = 0;
  size_t event_fp_offset = 0;
  uint32_t event_number = 0;
  event_fp.seekg(0, std::ios::beg);
  while(event_fp_offset < event_file_size)
    {
      event_fp.read(reinterpret_cast<char *>(event_buffer),
                    event_buffer_size * sizeof(NumT));

      // Populate the time of flight and pixel id
      // vectors with the data from the event file
      for(size_t event_buf_i = 0; event_buf_i < event_buffer_size; event_buf_i += 2)
        {
          // If the event_number is the same as the pulse index, then read from the 
          // pulse id buffer to get a new event time and pulse index
          if (event_number == pulse_index)
            {
              event_time_offset = 
                ((static_cast<NumT>(*(pulse_buffer + pulse_buf_i + 1))
                * NANOSECS_PER_SEC)
                + static_cast<NumT>(*(pulse_buffer + pulse_buf_i)))
                - ((init_seconds * NANOSECS_PER_SEC));
              pulse_buf_i += 4;
              if (pulse_buf_i == pulse_buffer_size)
                {
                  pulse_buf_i = 0;
                  pulse_fp_offset += pulse_buffer_size;
                  if(pulse_fp_offset + BLOCK_SIZE > pulse_file_size)
                    {
                      pulse_buffer_size = pulse_file_size - pulse_fp_offset;
                    }
                  pulse_fp.read(reinterpret_cast<char *>(pulse_buffer),
                                pulse_buffer_size * sizeof(NumT));
                }
              pulse_index = static_cast<NumT>(*(pulse_buffer + pulse_buf_i + 2));
            }

          // Filter out error codes
          if ((*(event_buffer + event_buf_i + 1) & ERROR) != ERROR)
            {
              // Get the proper bank from the bank map based on the pixel id
              Bank<NumT> *bank = this->bank_map[*(event_buffer + event_buf_i + 1)];
             
              // Place the pixel id and time of flight in the appropriate bank
              bank->tof.push_back(*(event_buffer + event_buf_i));
              bank->pixel_id.push_back(
                this->pixel_id_map[*(event_buffer + event_buf_i + 1)]);
             
              // If the bank has no pulse index or if a new event time has been
              // encountered, start with 1 as the events per pulse, and push back a 
              // new event time
              if (bank->pulse_index == -1 ||
                  event_time_offset !=
                  bank->pulse_time[bank->pulse_index])
                {
                  bank->pulse_index++;
                  bank->events_per_pulse.push_back(1);
                  bank->pulse_time.push_back(event_time_offset);
                }
              // If the event is still in the same pulse time, then simply increment
              // the event number for that pulse time
              else
                {
                  bank->events_per_pulse[bank->pulse_index]++;
                }
            }
          event_number++;
        }

      event_fp_offset += event_buffer_size;

      if(event_fp_offset + BLOCK_SIZE > event_file_size)
        {
          event_buffer_size = event_file_size - event_fp_offset;
        }
    }
  // Close event file
  event_fp.close();
}
