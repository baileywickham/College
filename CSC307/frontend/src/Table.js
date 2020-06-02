import React from 'react'
const Table = props => {
    const { characterData, removeCharacter } = props

    return (
        <table>
        <TableHeader />
        <TableBody characterData={characterData} removeCharacter={removeCharacter} />
        </table>
    )
}
const TableHeader = () => {
  return (
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Job</th>
      </tr>
    </thead>
  )
}
const TableBody = props => {
  const rows = props.characterData.map((row, index) => {
    return (
        <tr key={index}>
            <td>{row.id}</td>
            <td>{row.name}</td>
            <td>{row.job}</td>
            <td>
                <button onClick={() => props.removeCharacter(row.id)}>Delete</button>
            </td>
        </tr>
    )
  })

  return <tbody>{rows}</tbody>
}



export default Table
