export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8">
        <div className="text-center">
          <h1 className="text-3xl font-bold">Login</h1>
          <p className="mt-4 text-gray-600">
            This is a test login page to verify routing works.
          </p>
          <div className="mt-8 space-y-4">
            <a 
              href="/login/demo" 
              className="block w-full bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
            >
              Go to Demo Login
            </a>
            <a 
              href="/" 
              className="block w-full bg-gray-600 text-white px-4 py-2 rounded hover:bg-gray-700"
            >
              Back to Home
            </a>
          </div>
        </div>
      </div>
    </div>
  )
}