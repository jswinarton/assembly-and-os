void main()
{
    // Create a pointer to a char, and point it to the first text cell of video
    // memory
    char *video_memory = (char *)0xb8000;
    // Store the character "X" at the address.
    *video_memory = 'X';
}
