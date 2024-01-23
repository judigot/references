import { atom, useAtom } from "@/lib/jotai";

interface Props {
  name: string;
}

const pageAtom = atom<string>("HOME");

export default function App({ name }: Props) {
  const [page, setPage] = useAtom(pageAtom);
  return (
    <>
      Hey, {name}. Current Page: {page}
    </>
  );
}
