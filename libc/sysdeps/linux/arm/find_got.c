#include <link.h>
#include <unwind.h>

#if __FDPIC__
#include <bits/elf-fdpic.h>

struct got_callback_data
{
  _Unwind_Ptr pc;
  _Unwind_Ptr got;
};

static __always_inline int
__dl_addr_in_loadaddr(void *p, struct elf32_fdpic_loadaddr loadaddr)
{
	struct elf32_fdpic_loadmap *map = loadaddr.map;
	int c;

	for (c = 0; c < map->nsegs; c++)
		if ((void *)map->segs[c].addr <= p &&
		    (char *)p < (char *)map->segs[c].addr + map->segs[c].p_memsz)
			return 1;

	return 0;
}

/* Callback to return got value if module contain pc*/
static int
find_got_callback (struct dl_phdr_info * info, size_t size, void * ptr)
{
    int match = 0;
    struct got_callback_data *data = (struct got_callback_data *) ptr;

    if (__dl_addr_in_loadaddr((void *) data->pc, info->dlpi_addr)) {
        match = 1;
        data->got = (_Unwind_Ptr) info->dlpi_addr.got_value;
    }

    return match;
}

/* Find the got that correspond to module that contain PC.  */

_Unwind_Ptr __gnu_Unwind_Find_got (_Unwind_Ptr pc);
_Unwind_Ptr __gnu_Unwind_Find_got (_Unwind_Ptr pc)
{
  struct got_callback_data data;

  data.pc = pc;
  if (dl_iterate_phdr (find_got_callback, &data) <= 0)
    return 0;

  return data.got;
}
#endif

