/**
 * \file event_data.hpp
 * \brief The function declarations, includes, and class
 *        definition for event_data.cpp.
 */

#ifndef _EVENT_DATA_HPP
#define _EVENT_DATA_HPP 1

#include "nexus_util.hpp"
#include "bank_data.hpp"
#include <vector>
#include <string>
#include <cstdlib>
#include <libxml/tree.h>

namespace EventNexus
{
  const uint32_t ERROR = 0x80000000;
  const uint32_t NANOSECS_PER_SEC = 1000000000;
  const uint32_t EPOCH_DIFF = 631152000;
  const int DATA_SLAB_SIZE = 16777215;
  const std::string EST_WITH_DST = "04:00";
  const std::string EST_WITHOUT_DST = "05:00";
};

/** 
 * \enum e_data_name
 * \brief Enumeration of the data in the nexus file.
 * 
 * e_data_name is used primarily for the compiler
 * to catch any erronous values given to functions.
 */
typedef enum e_data_name
{
  TOF = 0,
  PIXEL_ID = 1,
  PULSE_TIME = 2,
  EVENTS_PER_PULSE = 3
};

/**
 * \struct Pulse
 * \brief Holds a pulse read in from a pulse id file. It
 *        is templated based on how the pulse id file is
 *        layed out. For example, making a 
 *        Pulse<uint32_t, uint32_t, uint64_t> struct will
 *        make a pulse struct with uint32_t nanosecond values,
 *        uint32_t second values, and uint64_t index values.
 */
template<typename NanosecondsT, 
         typename SecondsT, 
         typename IndexT>  
struct Pulse
{
  NanosecondsT nanoseconds;
  SecondsT seconds;
  IndexT index;
};

/**
 * \struct Event
 * \brief Holds an event read from a neutron event file. It
 *        is templated based on how the neutron event file is 
 *        layed out. For example, making a Event<uint32_t, uint32_t>
 *        struct will make an Event struct with uint32_t time of
 *        flight values and uint32_t pixel id values.
 */
template<typename TofT,
         typename PixelIdT>
struct Event
{
  TofT tof;
  PixelIdT pixel_id;
};

/**
 * \typedef TofType
 * \brief The type that a time of flight value is from the neutron
 *        event file.
 */
typedef uint32_t TofType;

/**
 * \typedef PixelIdType
 * \brief The type that a pixel id value is from the neutron event
 *        file.
 */
typedef uint32_t PixelIdType;

/**
 * \typedef NanosecondType
 * \brief The type that a nanosecond value is from the pulse id file.
 */
typedef uint32_t NanosecondType;

/**
 * \typedef SecondType
 * \brief The type that a second value is from the pulse id file.
 */
typedef uint32_t SecondType;

/**
 * \typedef PulseIndexType
 * \brief The type that a pulse index is from the pulse id file.
 */
typedef uint64_t PulseIndexType;

/** 
 * \typedef EventLayout
 * \brief Describes how an event in the neutron event file is structured.
 *        It is used throughout the program when reading in event structures.
 */
typedef Event<TofType, PixelIdType> EventLayout;

/**
 * \typedef PulseLayout
 * \brief Describes how pulse data in the pulse id file is structured.
 *        It is used throughout the program when reading in pulse structures.
 */
typedef Pulse<NanosecondType, SecondType, PulseIndexType> PulseLayout;

/**
 * \brief Turns a type (like uint32_t) into a valid nexus
 *        type. 
 * \return The enumerator for the nexus data type.
 * \exception runtime_error Thrown if the function isn't
 *                          instantiated for the type given.
 */
template <typename NumT>
inline e_nx_data_type typename_to_nexus_type(void);

/** 
 * \brief Takes a number of seconds since jan 1, 1990
 *        and converts it to an iso8601 date string.
 * \param seconds The number of seconds since jan 1, 1990.
 * \return The iso8601 string of the time.
 */
template <typename NumT>
std::string seconds_to_iso8601(const NumT seconds);
    
/**
 * \brief Fills in the nexus values associated with the
 *        e_data_name enumeration.
 * \param nx_data_type The enumeration specifying which piece
 *                     of data. Ex - TOF for time of flight.
 * \exception runtime_error Thrown if the enumeration value is 
 *                          invalid.
 * \return The string representation of the data. Ex - 
 *         "time_of_flight" for TOF.
 */
std::string get_nx_data_name(const e_data_name nx_data_type);

/** 
 * \brief Opens a bank in a nexus file
 * \param nexus_util The nexus utility with the open file handle.
 * \param bank_number The bank number to open.
 */
void open_bank(NexusUtil & nexus_util,
               const int bank_number);

/** 
 * \class EventData
 * \brief Holds all the data from the event file and
 *        includes the functions for working on the
 *        data. The template parameters are EventNumT
 *        and PulseNumT. These parameters describe what
 *        format the event numbers and pulse numbers 
 *        should be stored and written in. For exampls,
 *        Since the time of pulse offsets are kept 
 *        in nanoseconds, one might want to store the 
 *        pulse information in uint64s to avoid an overflow. 
 */
template <typename EventNumT, typename PulseNumT>
class EventData
{
  private:
    /**
     * \brief The vector used for mapping one pixel
     *        number to another.
     */
    std::vector<EventNumT> pixel_id_map;
    /**
     * \brief When the first time offset is read, it is converted to
     *        iso8601 form and stored in this variable so it can
     *        be written to the nexus file later.
     */
    std::string pulse_time_offset;
 
    /**
     * \brief The data that holds all the information from the banks.
     *        This includes the event and pulse id information.
     */  
    BankData<EventNumT, PulseNumT> bank_data;

    /**
     * \brief Writes the private data from EventData to a nexus file.
     * \param nexus_util The nexus utility with the open file handle.
     * \param nx_data The data to be written to the nexus file.
     * \param data_name The name of the data to be written 
     *                  (ex. time_of_flight).
     * \param bank_number The bank number of the data being written.
     */
    template <typename DataNumT>
    void write_private_data(NexusUtil & nexus_util, 
                            std::vector<DataNumT> & nx_data,
                            const std::string & data_name,
                            const int bank_number);

  public:
    /**
     * \brief Gets the initial pulse time offset string from the
     *        EventData class.
     * \exception runtime_error Thrown if the initial pulse offset hasn't
     *                          been read in.
     */
    const std::string & get_pulse_time_offset(void);

    /**
     * \brief Reads information from the event file and populates
     *        the tof and pixel id vectors.
     * \param event_file The event file to read from.
     * \param bank_file The bank configuration file.
     * \exception runtime_error Thrown if the event file can't be opened.
     */
    void read_data(const std::string & event_file,
                   const std::string & bank_file);

    /**
     * \brief Reads information from the pulse id file and event file.
     * \param event_file The event file to read from.
     * \param pulse_id_file The pulse id file to read from.
     * \param bank_file The bank configuration file. 
     * \exception runtime_error Thrown if any of the files
     *                          can't be opened.
     */
    void read_data(const std::string & event_file,
                   const std::string & pulse_id_file,
                   const std::string & bank_file);

    /**
     * \brief Takes a mapping file and creates a pixel id map.
     * \param mapping_file The mapping file to use.
     * \exception runtime_error Thrown if the mappging file doesn't
     *                          exist or if the data hasn't been read
     *                          in yet.
     */
    void create_pixel_map(const std::string & mapping_file);

    /**
     * \brief Writes the data to a nexus file. If pulse information
     *        hasn't been read in, then it only writes event information. 
     * \param nexus_util The nexus utility with the open file handle.
     */
    void write_nexus_file(NexusUtil & nexus_util);

    /**
     * \brief Writes a bank to a nexus file, using the write_data and
     *        write_attr functions.
     * \param nexus_util The nexus utility that has the open file handle.
     * \param bank_number The number of the bank to write.
     */
    void write_bank(NexusUtil & nexus_util, 
                    const int bank_number);
    /**
     * \brief Templated function that writes data to a nexus
     *        file.
     * \param nexus_util The nexus utility.
     * \param nx_data_name The enumeration specifying which 
     *                     piece of data to write.
     * \param bank_number The number of the bank to write data to.
     */
    void write_data(NexusUtil & nexus_util,
                    const e_data_name nx_data_name,
                    const int bank_number);

    /**
     * \brief Opens a data field in a nexus file and
     *        writes an attribute for it.
     * \param nexus_util The nexus utility.
     * \param attr_name The name of the attribute.
     * \param attr_value The value associated with
     *                   the attribute.
     * \param nx_data_name The enumeration specifying which
     *                     piece of data to write.
     * \param bank_number The bank number of the data.
     */
    void write_attr(NexusUtil & nexus_util,
                    const std::string & attr_name,
                    const std::string & attr_value,
                    const e_data_name nx_data_name,
                    const int bank_number);
  
    /**
     * \brief Constructor the EventData class.
     */
    EventData();

    /**
     * \brief The destructor for the EventData class.
     */
    virtual ~EventData();
};

#endif
