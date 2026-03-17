drivers/video/console/bitblit.c
```
static void bit_cursor(struct vc_data *vc, struct fb_info *info, int mode,
		       int softback_lines, int fg, int bg)
{
    ···
	// if (info->fbops->fb_cursor)
	// 	err = info->fbops->fb_cursor(info, &cursor);

	// if (err)
	// 	soft_cursor(info, &cursor);

	ops->cursor_reset = 0;
}
```