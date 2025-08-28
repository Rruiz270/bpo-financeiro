'use client'

export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-4">BPO Financeiro</h1>
        <p className="text-xl text-gray-600 mb-8">Sistema de Gestão Financeira para Empresas</p>
        <div className="space-x-4">
          <button
            className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
            onClick={() => alert('Login será implementado em breve!')}
          >
            Acessar Portal (Em breve)
          </button>
        </div>
      </div>
    </main>
  )
}