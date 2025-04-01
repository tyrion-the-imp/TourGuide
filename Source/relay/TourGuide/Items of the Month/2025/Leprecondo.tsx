import { List } from "@chakra-ui/react";
import { Item, totalTurnsPlayed } from "kolmafia";
import { $item, clamp, get, Leprecondo as LeprecondoLibram } from "libram";
import { ReactNode } from "react";

import Line from "../../../components/Line";
import Tile from "../../../components/Tile";
import { NagPriority } from "../../../contexts/NagContext";
import useNag from "../../../hooks/useNag";
import { haveUnrestricted } from "../../../util/available";
import { inventoryUseLink } from "../../../util/links";
import { capitalizeWords, commaOr, plural } from "../../../util/text";

function renderNeedBonus(
  need: LeprecondoLibram.Need,
  bonus?: LeprecondoLibram.Result,
): ReactNode {
  return (
    <>
      {capitalizeWords(need)}:{" "}
      {!bonus
        ? "nothing."
        : bonus instanceof Item
          ? `${bonus.identifierString}.`
          : Array.isArray(bonus)
            ? `${commaOr(bonus)}.`
            : `${bonus.effect.identifierString} (${bonus.duration} turns).`}
    </>
  );
}

const Leprecondo = () => {
  const leprecondo = $item`Leprecondo`;
  const haveLeprecondo = haveUnrestricted(leprecondo);

  const rearrangesLeft = LeprecondoLibram.rearrangesRemaining();
  const nextNeedCheck = clamp(
    5 - (totalTurnsPlayed() - get("leprecondoLastNeedChange")),
    0,
    5,
  );
  const needOrder = LeprecondoLibram.needOrder();
  const currentNeed = LeprecondoLibram.currentNeed();
  const needIndex = needOrder.indexOf(currentNeed);
  const unusedNeeds = LeprecondoLibram.NEEDS.filter(
    (need) => !needOrder.includes(need),
  );
  const nextNeedPossibilities =
    needIndex >= 0 && (needIndex + 1) % 6 < needOrder.length
      ? [needOrder[(needIndex + 1) % 6]]
      : unusedNeeds;

  const furniture = LeprecondoLibram.installedFurniture();
  const furnitureEmpty = furniture.every((f) => f === "empty");
  const bonuses = LeprecondoLibram.furnitureBonuses();
  const nextBenefits = nextNeedPossibilities.map(
    (need): [LeprecondoLibram.Need, LeprecondoLibram.Result | undefined] => [
      need,
      bonuses[need],
    ],
  );

  useNag(
    () => ({
      id: "leprecondo-setup-nag",
      priority: NagPriority.LOW,
      imageUrl: "/images/itemimages/leprecondo.gif",
      node: haveLeprecondo && rearrangesLeft > 0 && furnitureEmpty && (
        <Tile
          header="Set up Leprecondo"
          imageUrl="/images/itemimages/leprecondo.gif"
          href={inventoryUseLink(leprecondo)}
          linkEntireTile
        >
          Install furniture in your Leprecondo for bonuses.
        </Tile>
      ),
    }),
    [furnitureEmpty, haveLeprecondo, leprecondo, rearrangesLeft],
  );

  if (!haveLeprecondo) return null;

  return (
    <Tile
      header="Leprecondo"
      imageUrl="/images/itemimages/leprecondo.gif"
      href={inventoryUseLink(leprecondo)}
    >
      <Line>
        Next need check in {plural(nextNeedCheck, "turn")}.
        {nextBenefits.length > 0 &&
          (nextBenefits.length > 1 ? (
            " Possibilities:"
          ) : (
            <> {renderNeedBonus(nextBenefits[0][0], nextBenefits[0][1])}</>
          ))}
      </Line>
      {nextBenefits.length > 1 && (
        <List.Root>
          {nextBenefits.map(([need, bonus]) => (
            <List.Item key={need}>{renderNeedBonus(need, bonus)}</List.Item>
          ))}
        </List.Root>
      )}

      {rearrangesLeft > 0 && (
        <Line>
          {plural(rearrangesLeft, "furniture rearrangement")} remaining today.
        </Line>
      )}
    </Tile>
  );
};

export default Leprecondo;