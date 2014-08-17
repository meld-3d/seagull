import meld;
import derelict.opengl3.gl3;
import std.stdio;

void main()
{
	Window window = new Window("Seagull", 640, 480);
	
	Camera camera = new Camera(640, 480);

	new GameObject().Add!MeshRenderer(
		Mesh.CreatePlane(200.0f, 200.0f),
		new Material(Shader.Find("data/sea.glsl"))
	);

	auto seagull = new GameObject().Add!MeshRenderer(
		Mesh.LoadMesh("data/seagull.mdl"),
		new Material(Shader.Find("data/seagull.glsl"))
			.SetParameter("ambientColor", vec3(1.0f, 1.0f, 1.0f))
			.SetParameter("diffuseTex", new Texture("data/seagull.png"))
	);
	seagull.transform.transform = mat4.basis(vec3(0.0f, 2.0f, 20.0f), vec3(-1.0f, 0.0f, 0.0f), vec3.up);
	
	double currentTime = window.Time();
	double accumulator = 0.0;
	double dt = 1.0 / 60.0;

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

		glClearColor(0.7, 0.8, 0.9, 1.0);
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		Material.SetGlobalParameter("viewProj", camera.viewProj);
		Material.SetGlobalParameter("camPos", camera.pos);

		MeshRenderer.Draw();
		window.Swap();
	}
}
