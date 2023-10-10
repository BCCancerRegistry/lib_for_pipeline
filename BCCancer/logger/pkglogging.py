

import logging
import sys



def get_log_obj(name=None, logger=None,level:str = "info"):
    level = level.lower()
    log_lvl = dict(
        debug=logging.DEBUG,
        info=logging.INFO,
        warning=logging.WARNING,
        warn=logging.WARN,
        error=logging.ERROR,
        critical=logging.CRITICAL
    )

    if logger is None:
        if level not in log_lvl.keys():
            level = "info"
        if name is None:
            name = __name__
        log_format = '%(asctime)s %(name)-12s %(levelname)-8s %(message)s'
        logging.basicConfig(format=log_format, stream=sys.stdout)
        logger = logging.getLogger(name)
        logger.setLevel(log_lvl[level])
    else:
        logger.setLevel(log_lvl[level])
    return logger


if __name__ == "__main__":
    log = get_log_obj()
    log.info("TEST")
    log.warning("test_warning")
    log.debug("This should not get printed")
    log.error("Error msg")
    log.critical("Critical msg")
    log_new = get_log_obj(logger=log,level='debug')
    log_new.info("TEST")
    log_new.warning("test_warning")
    log_new.debug("This debug msg should get printed")
    log_new.error("Error msg")
    log_new.critical("Critical msg")
