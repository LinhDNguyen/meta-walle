/*  lensadjustment.c - The simple OKDA stereo camera kernel module.

* Copyright (C) 2018 Steinsvik AS
*/
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/interrupt.h>
#include <linux/spi/spi.h>

#include <linux/of_address.h>
#include <linux/of_device.h>
#include <linux/of_platform.h>

/* Standard module information, edit as appropriate */
MODULE_LICENSE("GPL");
MODULE_AUTHOR
    ("Steinsvik AS");
MODULE_DESCRIPTION
    ("lensadjustment - OKDA stereo camera Lenses Adjustment kernel module");

#define DRIVER_NAME "lensadjustment"

struct stereo_platform_data {

};

/* PARAMETERS */
int s_debug = 0;
module_param(s_debug, int, S_IRUGO);

/* */

static struct spi_board_info *spi_infos[] = {
	/* SPI0 */
	[0] = &(struct spi_board_info) {
		// .modalias = "stereo_spi0",
		.max_speed_hz = 13500000,
		.mode = SPI_MODE_0,
		.chip_select = 0,
		.bus_num = 0,
		.platform_data = NULL,
	},
	/* SPI1 */
	[1] = &(struct spi_board_info) {
		.modalias = "stereo_spi1",
		.max_speed_hz = 13500000,
		.mode = SPI_MODE_0,
		.chip_select = 0,
		.bus_num = 1,
		.platform_data = NULL,
		// .platform_data = &(struct stereo_platform_data) {
		// }
	}
};

static int spi_device_found(struct device *dev, void *data)
{
	struct spi_device *spi = container_of(dev, struct spi_device, dev);

	pr_info(DRIVER_NAME":      %s %s %dkHz %d bits mode=0x%02X\n",
		spi->modalias, dev_name(dev), spi->max_speed_hz/1000,
		spi->bits_per_word, spi->mode);

	return 0;
}

static void pr_spi_devices(void)
{
	pr_info(DRIVER_NAME":  SPI devices registered:\n");
	bus_for_each_dev(&spi_bus_type, NULL, NULL, spi_device_found);
}

static void fbtft_device_spi_delete(struct spi_master *master, unsigned int cs)
{
	struct device *dev;
	char str[32];

	snprintf(str, sizeof(str), "%s.%u", dev_name(&master->dev), cs);
	pr_info(DRIVER_NAME ": spi name %s will be deleted\n", str);

	dev = bus_find_device_by_name(&spi_bus_type, NULL, str);
	if (dev) {
		dev_info(dev, "Deleting %s\n", str);
		device_del(dev);
	}
}

static int lensadjustment_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct spi_master *master;
	struct spi_board_info *spi = spi_infos[0];
	struct spi_device *spi_dev;

	int rc = 0;
	dev_info(dev, "Module Probing\n");

	// First version, just listout all SPI drivers
	pr_spi_devices();

	master = spi_busnum_to_master(spi->bus_num);
	if (!master) {
		pr_err("spi_busnum_to_master(%d) returned NULL\n",
		       spi->bus_num);
		return -EINVAL;
	}

	/* make sure it's available */
	fbtft_device_spi_delete(master, spi->chip_select);
	dev_info(&master->dev, "SPI deleted\n");
	pr_info(DRIVER_NAME": spi bus num: %d\n", spi->bus_num);
	spi_dev = spi_new_device(master, spi);
	dev_info(&master->dev, "Create new device 0\n");
	put_device(&master->dev);
	dev_info(&master->dev, "Put new device 0\n");
	if (!spi_dev) {
		dev_err(&master->dev, "spi_new_device() returned NULL\n");
		return -EPERM;
	}
	dev_info(&master->dev, "CREATED DEVICE 0\n");

	return rc;
}

static int lensadjustment_remove(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	dev_info(dev, "Module remove\n");

	return 0;
}

#ifdef CONFIG_OF
static struct of_device_id lensadjustment_of_match[] = {
	{ .compatible = "steinsvik,stereo", },
	{ /* end of list */ },
};
MODULE_DEVICE_TABLE(of, lensadjustment_of_match);
#else
# define lensadjustment_of_match
#endif


static struct platform_driver lensadjustment_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table	= lensadjustment_of_match,
	},
	.probe		= lensadjustment_probe,
	.remove		= lensadjustment_remove,
};

static int __init lensadjustment_init(void)
{
	printk("<1>Hello module world.\n");

	return platform_driver_register(&lensadjustment_driver);
}


static void __exit lensadjustment_exit(void)
{
	// platform_driver_unregister(&lensadjustment_driver);
	printk(KERN_ALERT "Goodbye module world.\n");
}

arch_initcall(lensadjustment_init);
// module_init(lensadjustment_init);
module_exit(lensadjustment_exit);