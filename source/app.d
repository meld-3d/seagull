import meld;
import derelict.opengl3.gl3;
import std.stdio;

void main()
{
	Window window = new Window("Hello, world!", 640, 480);
	
	Camera camera = new Camera(640, 480);

	Shader shader = new Shader("data/specular.glsl");
	new GameObject().Add!MeshRenderer(
		Mesh.CreateCube(), 
		new Material(shader).SetParameter("ambientColor", vec3(1.0f, 0.0f, 0.0f))
	).transform.position = vec3(2.0f, 0.0f, 20.0f);
	new GameObject().Add!MeshRenderer(
		Mesh.CreateCylinder(20), 
		new Material(shader).SetParameter("ambientColor", vec3(0.0f, 0.0f, 1.0f))
	).transform.position = vec3(-2.0f, 0.0f, 20.0f);
	new GameObject().Add!MeshRenderer(
		Mesh.LoadMesh("data/mayor.obj"),
		new Material(shader).SetParameter("ambientColor", vec3(1.0f, 1.0f, 1.0f))
	).transform.position = vec3(0.0f, 0.0f, 20.0f);

	double currentTime = window.Time();
	double accumulator = 0.0;
	double dt = 1.0 / 60.0;

	void test(string file)
	{
		writeln("Change: " ~ file);
	}
	FileWatcher.RegisterCallback("data", &test);

	while (window.IsRunning())
	{
		double newTime = window.Time();
		double frameTime = newTime - currentTime;
		currentTime = newTime;

		accumulator += frameTime;
		while (accumulator >= dt)
		{
			float delta = dt * 4.0f;
			if (Input.IsKeyDown(Keys.A))
				camera.Move(delta, 0.0f);
			if (Input.IsKeyDown(Keys.D))
				camera.Move(-delta, 0.0f);
			if (Input.IsKeyDown(Keys.W))
				camera.Move(0.0f, delta);
			if (Input.IsKeyDown(Keys.S))
				camera.Move(0.0f, -delta);

			if (Input.IsKeyDown(Keys.E))
				camera.Look(delta*2.0, 0.0f);
			if (Input.IsKeyDown(Keys.Q))
				camera.Look(-delta*2.0, 0.0f);
			if (Input.IsKeyDown(Keys.R))
				camera.Look(0.0f, delta);
			if (Input.IsKeyDown(Keys.F))
				camera.Look(0.0f, -delta);

			accumulator -= dt;
		}

		glClearColor(0.0, 0.2, 0.8, 1.0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		shader.SetParameter("viewProj", camera.viewProj);

		MeshRenderer.Draw();
		
		FileWatcher.Update();

		window.Swap();
	}
}
