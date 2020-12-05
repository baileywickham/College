SYSCALL_DEFINE1(mysyscall, char *, msg)
{
    char buf[256];
    long copied = strncpy_from_user(buf, msg, sizeof(buf));
    if ( copied < 0 || copied == sizeof(buf) )
        return -EFAULT;
    printk(KERN_INFO "mysyscall called with \"%s\"\n", buf);
    return 0;
}

SYSCALL_DEFINE2(mysyscall2, char *, msg, long, size)
{
    long copied;
    char *buf;
    int i = 0;
    /* declare additional variable(s) as needed */

    buf = (char *)kmalloc(size, GFP_KERNEL);
    if ( buf == NULL ) {
        printk(KERN_INFO "mysyscall2 kmalloc\n");
        return -EFAULT;
    }

    copied = copy_from_user(buf, msg, size); /* returns zero on success */
    if ( copied )
        return -EFAULT;
    printk(KERN_INFO "mysyscall2 received: \"%s\" %ld\n", (char *)buf, size);

    /* NEED to add code here to convert lower/upper (and vice versa) */
    while (buf[i]) {
        if (buf[i] >= 65 && buf[i] <= 90) {
            buf[i] = buf[i] + 32;
        } else if (buf[i] >= 97 && buf[i] <= 122) {
            buf[i] = buf[i] - 32;
        }
        i++;
    }

    copied = copy_to_user(msg, buf, size); /* returns zero on success */
    if ( copied )
        return -EFAULT;
    printk(KERN_INFO "mysyscall2 returned: \"%s\"\n", (char *)buf);

    kfree(buf);

    return 0;
}

