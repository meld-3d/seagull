import meld;

void main()
{
	Window window = new Window("Hello, world!", 640, 480);

	while (window.IsRunning())
	{
		window.Swap();
	}
}
